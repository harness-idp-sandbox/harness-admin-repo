# terraform.tfvars (rendered by Cookiecutter, no secrets)
org_id               = "{{ cookiecutter.org_identifier }}"
project_id           = "{{ cookiecutter.project_identifier }}"

service_id           = "{{ cookiecutter.service_identifier }}"
service_name         = "{{ cookiecutter.project_name }}"
docker_connector_ref = "{{ cookiecutter.docker_connector_ref }}"
image_repo           = "{{ cookiecutter.docker_registry }}/{{ cookiecutter.docker_image_name }}"
image_tag            = "latest"
