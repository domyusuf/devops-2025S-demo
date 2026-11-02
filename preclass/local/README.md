# Local Terraform exercise

This configuration manages a Docker image and container using Docker Desktop.
The existing AWS configuration in `../../terraform/` is separate from this exercise.

## Run

Start Docker Desktop, then run these commands from this directory:

```sh
terraform init
terraform validate
terraform plan -var='image=dominionyusuf/campus-event-notifier:v1'
terraform apply -var='image=dominionyusuf/campus-event-notifier:v1'
terraform output app_url
curl http://localhost:8080/health/
```

The expected health response is `{"status": "ok"}`.
The initial plan creates two managed resources: `docker_image.app` and
`docker_container.app`. The `app_url` output does not create a resource.

## Container replacement experiment

After adding a disposable event through `/admin/`, change the external port:

```sh
terraform plan -var='image=dominionyusuf/campus-event-notifier:v1' -var='external_port=8081'
terraform apply -var='image=dominionyusuf/campus-event-notifier:v1' -var='external_port=8081'
```

The port change forces container replacement. SQLite data in the old container's
writable layer is lost, including the event and any demo administrator account.
The image remains unchanged. A persistent volume or external database would be
needed to retain application data across replacements.

## Cleanup

```sh
terraform destroy -var='image=dominionyusuf/campus-event-notifier:v1' -var='external_port=8081'
```

Terraform state and local variable files are ignored by Git. Commit the provider
lock file so future initialization uses the same provider version.

These Terraform files were prepared with AI assistance.
