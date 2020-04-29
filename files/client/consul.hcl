datacenter = "london"
data_dir = "/opt/consul"
encrypt = "kUNih7XKcNc0qqQFssC+7TW6vghZ8MXiPmjwaUGkyO4="
retry_join = ["provider=gce project_name=tharris-demo-env tag_value=dev-stack"]
bind_addr = "{{GetInterfaceIP \"eth0\"}}"

