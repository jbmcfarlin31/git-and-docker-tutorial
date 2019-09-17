# What is Github and Gitlab?

## Github
Github is an open-source platform that is used for version control and source control. It is sometimes referred to as:
 - Version Control System (VCS)
 - Source Control Manager (SCM)

 Github was originally created by the same individual who founded Linux, Linus Trovalds. It is usually referred to as `Git`. Git allows an individual, company, developer, student, virtually anyone to store data. This data can be code files, configuration files, documentation files, you name it. Git can also be used to store binaries or programs as well.

 Git is primarily used to host other open-source projects, as it provides a centralized area for developers to contribute, the community to consume, and feedback to be generated for future versions to come.

 Even if you are not a developer or contributor, you can still use git to view code, documentation, programs, etc., the best part about git though is that you can have a centralized project (or repository) to not only contain your files, but it can also be used to track file changes, track issues (also known has bugs or feature enhancements) that may have been found within the code or program. 

 The details of how Git works will be described further down below.

 ## Gitlab

 GitLab is also a VCS and SCM tool much like Github, the key difference of what it does over the other though is in the name. Github indicates a `hub`, which means a location or place. GitLab indicates a `lab` or environment for the files contained in the project repository. 

 GitLab has a lot of the same capabilities that GitHub does, however it also has significant features that GitHub does not have. For example, GitLab can do the following:
  - Built-in continuous integration and delivery (CI/CD) (free nonetheless), whereas GitHub supports this via a 3rd party entity.
  - Innersourcing which allows developers to promote it via their own internal repositories.
  - Importing and Exporting data can be done seamlessly across multiple sources whereas GitHub is restricted
  - Automated application performance monitoring
  - More focused on Agile development providing weighting capabilities
  - Can be installed locally on-premise to run as your own instance and configuration
    - This means local authentication can be restricted to LDAP, Kerberos, Basic, and even SAML2 or OAuth.

The biggest difference in my opinion is the ability to use the CI/CD pipeline feature to build out the way an application is built, tested, and promoted between dev, qual, and production environments. This will come into place later on when we cover Docker. Third party tools can do this same thing in GitHub, likee TravisCI or Jenkins, but usually you are limited to how many builds you are allowed or you have to pay a fee. GitLab has this feature built-in out of the box, so you are able to utilize it right away.

## So I can store my files online, so what?

So now that you understand what Git is and what a source control system is, lets talk about how you can use it and the benefit it provides. Git has a process for versioning files, tracking changes, and making updates to those files.

Since Git used primarily has a code repository, we are going to assume that perspective from here on.

If I am a developer who wants to write scripts in a programming language, or write an open-source program that can be used to integrate with something, I am going to store is in Git so that I can have a centralized location for all of my source code files, and if others want to help me with, I can add them to allow that capability. So now, how does Git handle multiple people contributing and writing code and pushing it to the repository? Won't that overwrite the changes someone else could have done?

The short answer is, YES! One can absolutely overwrite changes to someone elses code if a proper workflow has not beeen defined. So what does a workflow typically look like?

A Git workflow typically consists of a checkout of a branch, modifications to that branch, commiting the new changes to the branch, pushing those changes to the online source, and issuing a pull request (or merge request in GitLab). Lets break this down a little bit to understand each process.

Say I have a Python game called [`Rock, Paper, Scissors`](https://github.com/jbmcfarlin31/python-rock-paper-scissors) (no really, I do!).

I am a developer playing the game and I decide, _"hey, I would like to add a feature to this game"_. The workflow would look something like:
- Checkout the *master* branch
  - `git checkout -B myfeature <repo_url> origin master`
- Make my changes to the code
  - `print("Hey, this game rocks!")`
- Add and commit these changes to my local repository
  - `git add . && git commit -m "add print statement"`
- Push these changes to the repo as this new branch
  - `git push origin myfeature`

At this point, my changes have been implemented into the `myfeature` branch, and I am now ready to issue a pull request. The pull request basically tells the owner of the repo, _"Hey, Jane Doe wants to add the feature they added in the `myfeature` branch to your main branch. Is this okay?"_. It is up to the contributors or owner of the project to verify the changes, ensure they won't break anything in the project, and if approved it can be merged into the main project source code. You can also add in additional tests and pipelines to perform unit tests, integration tests, stress tests, etc.

So your probably thinking, _"What does it mean to checkout a repo?", "What is branch?", "What is a local repository?", "What does push do?"_, and  these are all good questions, so let's define some of these terms.
### Definitions

- To <b>_checkout_</b> a repository means to basically `clone` it to your local box. When you issue a `git checkout <repo>` command, this performs an advanced `curl` command basically to copy everything in the online repo to the machine you are logged in on.

- A <b>_branch_</b> in git is a way for isolating code changes without affecting the `production` environment or other developers. By default, when a project is created, a default branch of `master` gets built. Now there are various ways for performing code changes and what not, so I won't get into that here because it depends on the organization and requirements of the project. Typically, `master` is to not be touched. All code that is running in `production` should be what is in `master`. If you wanted to make a change to something, you would not want to touch `production` in the event the change could take it down. So you create a "copy" if you will of `master` in a new branch, so changes do not affect what is currently running. Think of branches as separate environments.

- A <b>_local repository_</b> gets created when you perform a `git checkout` command. This is explained above in the `checkout` definition. It is basically a directory and file copy to the local box of what exists in the repo.

- To <b>_commit_</b> to a local repository means to basically save your changes that you made to the files so that when you issue a `push` command they will be transfered up into the online repo. The `commit` tag usually always comes with what is called a `commit message`. This commit message usually follows a format depending on the requirements, but it lets other developers and contributors know what was changed. For example if you had a typo in the following code snippet and changed it:
  ```python
  # Before
  print("Helloooo World")

  # After
  print("Hello World")
  ```
  You could have a commit message that says:
  `git commit -m "fixed typo in app.py"`

- To <b>_push_</b> into a repository means to basically take the local changes in your local repository and transfer them to the online repository so that it can be tracked. Think of the command `git push` as a `cp src dest` command.

- A <b>_pull request_</b> means to basically perform a confirmation with the project owner or contributors that says, _"I want to put my changes into your source code"_, allowing your feature to be implemented. This is only done if the changes will not break current source code, and usually after extensive tests have been performed.

One of the cool features of Git is that you can track changes to files. For example, if production was running and all of a sudden went down and you knew there was a code merge that day you can easily figure out what was changed and broke it. This is done through the `git diff` command after changes have ben applied. It will usually output the files that have been modified and you can see what lines are were changed (down to the line number itself!).

Here is an example:
```bash
$ git checkout https://github.com/username/mycoolrepo.git
$ echo "hello world" > hello.txt
$ git add .
$ git commit -m "add hello.txt"
$ git push
$ echo "goodbye world" >> hello.txt
$ git diff
$ >>> show example here
```

## I think I 'Git' it... get it?

So now that you understand Git, let's take a look at what is commonly used with it. Git has historically been used with source code, but with current technology, it is now being used to help faciliate the automation behind microservices. I'm sure you are overloaded with definitions right now, so I won't go into what microservices are here - but if you are curious, you can read this article about it: [What is a Microservice?](https://microservices.io/)

Microservices are genuinely run as [containers](https://www.docker.com/resources/what-container) (which is another definition in and of itself), and the containers run on a piece of softwarer called [Docker](https://www.docker.com/). 

If you are ready to see how Git can be used alongside with Docker, please continue on the tutorials by clicking here: [What is Docker?](https://github.com/jbmcfarlin31/git-and-docker-tutorial/what-is-docker.md)