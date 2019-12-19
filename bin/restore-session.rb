#!/usr/bin/env ruby

require 'open3'
require 'yaml'

# ==============================================================================
# ARGUMENTS
# ==============================================================================
usage = "USAGE: #{$0} [SESSION]..."

# Get sessions to restore
sessions = ARGV
if sessions.empty?
	puts usage
	exit 2
end


# ==============================================================================
# FUNCTIONS
# ==============================================================================
def tmux_has_session(session_name)
	has_session_cmd = ['tmux', 'has-session', '-t', session_name]
	stdout, stderr, status = Open3.capture3(*has_session_cmd)
	return status.exitstatus == 0
end


# ==============================================================================
# RESTORE SESSION(S)
# ==============================================================================
backup_dir = "#{ENV['HOME']}/.tmux/saved-sessions"

# TODO: Unhardcode
shell = 'zsh'

# For each session
sessions.each do |session_name|

	# Load .yaml file
	restore_file = Dir.glob("#{backup_dir}/#{session_name}/*.yaml").sort.last
	if restore_file.nil?
		puts "ERROR: Unable to find saved session for '#{session_name}'"
		next
	end
	session_info = YAML.load(File.read(restore_file))

	# Initialize variables
	pane_id = nil
	prev_index = -1

	# For each window
	session_info.each do |index, window_info|

		name = window_info['name']
		layout = window_info['layout']

		# For each pane
		window_info['panes'].each do |path|

			# Create new session if it doesn't exist
			if not tmux_has_session(session_name)
				new_session_cmd = ['tmux', 'new-session', '-d']
				new_session_cmd += ['-s', session_name]
				new_session_cmd += ['-n', name] unless name.nil?
				new_session_cmd += ['-c', path] if File.directory?(path)
				new_session_cmd += ['-P', '-F', '#{pane_id}']
				new_session_cmd += [shell]
				stdout, stderr, status = Open3.capture3(*new_session_cmd)
				if status.exitstatus != 0
					$stderr.puts "ERROR: Unable to create new session for '#{session_name}'"
					$stderr.puts "tmux error: '#{stderr}'" unless stderr.empty?
					exit status.exitstatus
				end
				pane_id = stdout.chomp

			# Create new window
			elsif prev_index != index

				new_window_cmd = ['tmux', 'new-window']
				new_window_cmd += ['-t', session_name]
				new_window_cmd += ['-n', name] unless name.nil?
				new_window_cmd += ['-c', path] if File.directory?(path)
				new_window_cmd += ['-P', '-F', '#{pane_id}']
				new_window_cmd += [shell]
				stdout, stderr, status = Open3.capture3(*new_window_cmd)
				if status.exitstatus != 0
					$stderr.puts "ERROR: Unable to create new window index '#{index}'"
					$stderr.puts "tmux error: '#{stderr}'" unless stderr.empty?
					exit status.exitstatus
				end
				pane_id = stdout.chomp
				#puts "New window pane ID: #{pane_id}"

			# Split current window to create a new pane
			else
				split_window_cmd = ['tmux', 'split-window', '-h']
				split_window_cmd += ['-t', pane_id] unless pane_id.nil?
				split_window_cmd += ['-c', path] if File.directory?(path)
				split_window_cmd += [shell]
				stdout, stderr, status = Open3.capture3(*split_window_cmd)
				if status.exitstatus != 0
					$stderr.puts "ERROR: Unable to create new window index '#{index}'"
					$stderr.puts "tmux error: '#{stderr}'" unless stderr.empty?
					exit status.exitstatus
				end
			end

			prev_index = index

		end # for each pane

		# Select layout after panes are created
		if layout
			layout_cmd = ['tmux', 'select-layout', '-t', pane_id, layout]
			stdout, stderr, status = Open3.capture3(*layout_cmd)
			if status.exitstatus != 0
				$stderr.puts "Unable to select layout for '#{index}'"
				exit status.exitstatus
			end
		end

	end # for each window
end # for each session


