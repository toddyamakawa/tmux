#!/usr/bin/env bash
awk '
	/^MemTotal:/     { total=$2 }
	/^MemFree:/      { free=$2 }
	/^Buffers:/      { buffers=$2 }
	/^Cached:/       { cached=$2 }
	/^Shmem:/        { shmem=$2 }
	/^SReclaimable:/ { srec=$2 }
	END { printf "[%0.1f/%d GB]", (total-free-buffers-cached+shmem-srec)/1048576, total/1048576 }
' /proc/meminfo

