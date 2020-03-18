{
  "datacenter": "london-dc",
  "data_dir": "/opt/consul",
  "log_level": "INFO",
  "server": true,
	"bootstrap-expect": 3,
  "auto-pilot": {
    "dead_server_cleanup": true,
  }, 
  "encrypt": "kUNih7XKcNc0qqQFssC+7TW6vghZ8MXiPmjwaUGkyO4=",
  "retry_join" : ["provider=gce project_name=tharris-demo-env tag_value=dev-stack"]
  }
}