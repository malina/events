## Teachbase test app

### Requirements

* Ruby >= 2.0

* PostgreSQL >= 9.3

* Redis

### Wanna use Vagrant?

Use (https://github.com/webils/tb_vagrant_ansible.git)[https://github.com/webils/tb_vagrant_ansible.git].

### Other

To login into application use credentials in _seed.rb_.

To populate db with data
```
rake populate:users
rake populate:meetings # create users before creating meetings!
```
