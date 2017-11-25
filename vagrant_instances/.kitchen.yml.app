---
driver:
  name: vagrant

provisioner:
  name: chef_zero
  require_chef_omnibus: true
  chef_omnibus_url: file:///mnt/share/scripts/install.sh
  environments_path: /Users/ongomr/DevOps/chef/envs
  roles_path: /Users/ongomr/DevOps/chef/roles

platforms:
  - name: centos7
    driver:
      customize:
       memory: 1028
       cpus: 1
      box: centos7
      box_url: /Users/ongomr/DevOps/vagrant/boxes/centos7.box
      network:
      - ["private_network", {ip: "192.168.56.80"}]
      synced_folders:
      - ["/Users/ongomr/DevOps/chef/share/", "/mnt/share", "disabled: false"]

# Allocation Range started at IP: 192.168.56.100
suites:
  - name: default
    environment: lab
    driver:
      vm_hostname: elksrv
      customize:
       memory: 4096
       cpus: 2
      network:
      - ["private_network", {ip: "192.168.56.110"}]
    run_list:
      - recipe[elkstack::default]
    excludes:
      -
    attributes:
