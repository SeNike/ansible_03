python3 update_prod_yaml.py
ansible-playbook -i inventory/prod.yml site.yml -v
terraform apply

eval `ssh-agent -s`
ssh-add -l
ssh-add ~/.ssh/id_rsa