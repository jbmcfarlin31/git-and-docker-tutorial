# How can git be used with Docker?

So now that you have read the differences between GitHub and GitLab, and also got your toes wet with what Docker and microservices are, you are probably wondering now how you can combine two together.

Git can be used with Docker in many ways. The most common is using git as the repository where code is stored for an application and leveraging docker to and CI/CD pipelines to build that application, deploy it, and test it.

Here is an example, say I have a python application that deploys a web server filled with some basic API endpoints.

The workflow for traditionally building this application might look something like:
- Get my sysadmin to give rights and permissions to a VM
- Get my code put onto the VM
- Test my code and ensure it is working and ready
- Deploy to production


Let's look at this same approach using modern methodologies:
- Use git to store the code (since we can ingest with `git clone`)
- Use git to configure the CI/CD process for building and deploying the application within docker
- Test the application
- Rinse and Repeat!

All of this can happen on a server or without a server, like a local box. This allows the developer to perform their own duties, building and deploying their own application, and then being able to test or allow QA to test. This also gives the developers a way to version their application builds using docker tags (e.g. latest, v1, v2, etc.). 
