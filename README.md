# project-tmp

## Description

This is a template to setup a dockerized fullstack app and deploy it to Azure as Web App.

## Prerequisites

- Existing azure subscription
- az cli installed
- docker installed and running
- terraform installed

## Usage

1. Create a new project from this template
2. Run `az login`
3. In terraform directory create terraform.tfvars file and fill in the correct variable values.
4. Cd into terraform directory and run `terraform init && terraform apply`
5. In Azure Portal go to your server app and click "Deployment Center" (in left panel)
6. For "Source" choose github actions, fill in the desired values and click "save"

Repeat steps 5-6 with your client app.

### Configure github actions

Now we need to add some configurations to the github actions that were generated for us by Azure.

1. In your github repository add a secret:

- go to: settings > Secrets and variables > Actions
- click "New repository secret" button
- add name: VITE_API_URL
- add Secret (replace "my-server" with your own server app name): https://my-server.azurewebsites.net/api
- click "Add secret"

2. Edit the .github/workflows/main_client.yml file. You need to set build-args and build context to the client folder like so:

```
-name: Build and push container image to registry
	uses: docker/build-push-action@v2
	with:
		…
		context: ./client
		file: ./client/Dockerfile
		build-args: |
			VITE_API_URL=${{ secrets.VITE_API_URL }}
```

3. Repeat step 2 with server yml file, but point build to server folder and leave out build-args since the server doesn't use them.

After committing the action edits your app should be up and running with client app showing text "Hello From Server!". It might take a few minutes for azure to update everything.
