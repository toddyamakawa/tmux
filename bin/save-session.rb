#!/usr/bin/env ruby

require 'open3'
require 'yaml'

# ==============================================================================
# ARGUMENTS
# ==============================================================================

# Get sessions
sessions = ARGV

if sessions.empty?

	# Get current session name
	session_name_cmd = ['tmux', 'display-message', '-p', '#{session_name}']
	stdout, stderr, status = Open3.capture3(*session_name_cmd)
	if status.exitstatus != 0
		$stderr.puts stderr unless stderr.empty?
		$stderr.puts "Command '#{$1.join(' ')}' failed"
		exit status.exitstatus
	end

	# Append current session name
	sessions.append(stdout.chomp)
end

# ==============================================================================
# SAVE SESSION(S)
# ==============================================================================
backup_dir = "#{ENV['HOME']}/.tmux/saved-sessions"
today = Time.now.strftime('%Y-%m-%d')
pane_info = ['window_index', 'window_name', 'window_layout', 'pane_current_path']
pane_format = pane_info.map { |info| "\#{#{info}}" }.join("\t")

sessions.each do |session_name|
	save_file = "#{backup_dir}/#{session_name}/#{today}.yaml"

	# Get window/pane info from session
	session_info_cmd = ['tmux', 'list-panes', '-F', pane_format, '-s', '-t', session_name]
	stdout, stderr, status = Open3.capture3(*session_info_cmd)
	if status.exitstatus != 0
		$stderr.puts stderr unless stderr.empty?
		$stderr.puts "Command '#{$1.join(' ')}' failed"
		exit status.exitstatus
	end

	info = Hash.new
	stdout.split("\n").each do |line|
		index, name, layout, path = line.split("\t")
		index = index.to_i
		info[index] ||= Hash.new
		info[index]['name'] = name
		info[index]['layout'] = layout
		info[index]['panes'] ||= Array.new
		info[index]['panes'].append(path)
	end

	File.write(save_file, info.to_yaml)
end


