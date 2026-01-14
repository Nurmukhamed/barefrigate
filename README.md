# barefrigate
A Ansible playbooks to extract files from docker image and run on bare server.

You need 2 computers.

First computer ( linux, macos, windows with wsl maybe) is used to run command, ansible playbooks. Let's call it Computer-A.
Requirements - installed python3, installed ansible package.

Second computer is Debian OS running. Where files are extracted, packages are installed. Let's call it Computer-B.
Requirements - running Debian 12, enough space to store compressed file, uncompressed files (at least 12 GB).

## **Computer-A**: Pull and extract frigate docker image. 

Computer-B user is support, Computer-B ip is 192.168.1.17 for example.

Run command:

~~~bash
cat pull_extract_docker_image.sh | ssh support@192.168.1.17
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

## **Computer-A**: Setup and activate ansible.

In linux, macos you may install ansible using venv.

~~~bash
python3 -m venv ~/ansible
python3 -m pip install pip --upgrade
python3 -m pip install ansible ansible-lint yamllint
~~~

To activate ansible use this command

~~~bash
source ~/ansible/bin/activate
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

## **Computer-A**: Cleaning after install on Computer-B.

Run command:

~~~bash
cat cleanup.sh | ssh support@192.168.1.17
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

