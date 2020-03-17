datacenter = "london-dc"
data_dir = "/opt/consul"
encrypt = "{{ encrypt }}"
retry_join: ["provider=gce project_name="{{project_name}}" tag_value=dev-stack"]
