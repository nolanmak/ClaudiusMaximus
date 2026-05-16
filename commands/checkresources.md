# Check Resources

Perform an in-depth analysis of resource utilization on this macOS machine. Run all necessary CLI commands (ps, vm_stat, top, docker stats, etc.) to gather a complete picture, then present a structured report.

## Data to collect

Run these in parallel where possible:

1. **System overview**: Total RAM, CPU cores, memory pressure (`memory_pressure`), swap usage (`sysctl vm.swapusage`), load averages (`sysctl -n vm.loadavg`), uptime
2. **Per-process resource usage**: `ps aux -r` and `ps aux -m` for top CPU and memory consumers. Collect all processes, not just top 10.
3. **Zombie processes**: `ps aux | grep -E '^.*Z'` — find any zombie (defunct) processes
4. **Orphaned/stale processes**: Look for processes that have been running unusually long with no parent, or background tasks tied to projects/directories that may no longer be active (e.g. old dev servers, watchers, build tools, node/bun/python processes serving dead projects)
5. **Docker containers**: If Docker is running, `docker stats --no-stream` for container-level CPU/memory breakdown
6. **Disk usage**: `df -h /` for root volume free space
7. **Network listeners**: `lsof -iTCP -sTCP:LISTEN -nP` to find all processes holding open ports

## Report format

Organize findings into these sections:

### 1. System Health Summary
- RAM: used / total, memory pressure percentage, swap usage
- CPU: load average vs core count, overall busy percentage
- Disk: free space remaining

### 2. Resource Usage by Category
Group processes into categories and rank by total resource consumption:
- **Browsers** (Chrome, Safari, Firefox — include all helper/renderer processes summed)
- **Development tools** (IDEs, Claude Code sessions, language servers, linters, bundlers)
- **Docker / Containers** (VM overhead + individual container breakdown)
- **Background services** (Ollama, spotlight, backup agents, sync tools)
- **System processes** (WindowServer, kernel_task, coreaudiod, etc.)
- **Other**

For each category show total CPU% and total RAM in MB/GB.

### 3. Zombie & Suspect Processes
- List any actual zombie processes (state Z)
- Flag processes that look stale: dev servers for projects not recently touched, orphaned node/bun/python watchers, build processes that finished but didn't exit, duplicate instances of the same tool
- Flag any process using significant resources (>100MB RAM or >5% CPU) that doesn't appear to be actively needed

### 4. Port Hogs
- List all listening ports, grouped by process, noting any conflicts or unusual listeners

### 5. Optimization Recommendations
Rank suggestions by impact (most resources freed first):
- Specific processes to kill (with the `kill` command ready to copy)
- Chrome tabs/renderer processes that could be closed
- Docker containers that could be stopped
- Background services that could be disabled
- General tips based on current memory pressure

Be direct and opinionated. If something looks wasteful, say so. Provide copy-pasteable commands for every recommendation.
