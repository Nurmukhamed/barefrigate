# barefrigate
A Ansible playbooks to extract files from docker image and run on bare server.

You need 2 computers.

First computer ( linux, macos, windows with wsl maybe) is used to run docker command, ansible playbooks. Let's call it Computer-A.
Requirements - running docker, enough space to pull docker images (at least 4GB), enough space to extract, compress files from docker image (at least 10GB).  

Second computer is Debian OS running. Where files are extracted, packages are installed. Let's call it Computer-B.
Requirements - running Debian 12, enough space to store compressed file, uncompressed files (at least 12 GB).

## **Computer-A**: Pull and extract frigate docker image. 

Run command:

~~~bash
bash pull_extract_docker_image.sh
~~~

## **Computer-A**: Copy compressed file to Computer-B.

Computer-B user is support, Computer-B ip is 192.168.1.17 for example.

Run command:

~~~bash
ssh support@192.168.1.17 "mkdir -p /home/support/barefrigate/frigate"
scp frigate.tar.gz support@192.168.1.17:/home/support/barefrigate
ssh support@192.168.1.17 "cd /home/support/barefrigate/frigate; tar zxvf ../frigate.tar.gz"
~~~

## **Computer-B**: Discover frigate filesystem uuids and set them as environment variables.

**TODO**: Update it.

Frigate requires that /config, /db, /media/frigate folders are mounted. 
So we need to create this mount points, discover their uuid.

## **Computer-A** Set frigate filesystem uuids for ansible playbook.

Run command

~~~bash
export FRIGATE_CONFIG_UUID="FRIGATE_CONFIG_UUID"
export FRIGATE_DB_UUID="FRIGATE_DB_UUID"
export FRIGATE_STORAGE_UUID="FRIGATE_STORAGE_UUID"
~~~

## **Computer-A**: Run Ansible playbook.

**TODO** Update it

First check if ansible can ping Computer-B.

Run command:

~~~bash
cd $HOME/barefrigate
ansible -m ping all
~~~

Then run ansible playbook.

Run command:

~~~bash
ansible-playbook main.yaml
~~~

## Links:

* https://labs.iximiuz.com/tutorials/extracting-container-image-filesystem
* https://docs.ansible.com/projects/ansible/3/collections/ansible/builtin/apt_module.html
* https://stackoverflow.com/questions/58169348/how-is-the-architecture-fact-called-in-ansible
* https://docs.ansible.com/projects/ansible/latest/collections/community/general/alternatives_module.html
* https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/apt_repository_module.html
* https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/unarchive_module.html
* https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/lineinfile_module.html
* https://peateasea.de/avoiding-ansible-apt-key-on-debian/
* https://www.reddit.com/r/ansible/comments/1hsa2v2/is_there_a_builtin_way_to_add_an_apt_repo_with_a/
* https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/get_url_module.html
* https://github.com/just-containers/s6-overlay

