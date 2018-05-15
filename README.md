# kubernetes-management-tools

Managing multiple Kubernetes deployments across many cloud providers can become a bit clumbersome
so I decided to write a few tools to ease with this pain.

Currently this tool will work with Kubernetes clusters on the following platforms:

* Google cloud engine  (gcloud)
* AWS (aws)
* Minikube (minikube, local development only)
* Generic certificate connected clusters (standalone)

## Requirements

* Minikube installed and configured for "minikube" platform usage
* Docker installed
* YQ installed <https://github.com/kislyuk/yq>(https://github.com/kislyuk/yq)
* GCloud SDK for "gcloud" platform usage
* AWS SDK for "aws" platform

## Usage

Clone this repository, and run the install script to auto configure this repository

```
git clone https://github.com/vulgarmadman/kubernetes-management-tools.git
Cloning into 'kubernetes-management-tools'...
remote: Counting objects: 10, done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 10 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (10/10), done.

cd kubernetes-management-tools
bash install-tools.sh
```

To manually setup and configure

Clone this repository and copy the example config to config.json and manually add
entries into this

```
git clone https://github.com/vulgarmadman/kubernetes-management-tools.git
Cloning into 'kubernetes-management-tools'...
remote: Counting objects: 10, done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 10 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (10/10), done.

cd kubernetes-management-tools
cp config.json.example config.json
```

It is also recommended so add kubernetes-management-tools/bin to your path

## Tools

Provide are tools to configure access to Kubernetes clusters and authenticate against docker repos

### kube-auth

**kube-auth** is used to login to a kubernetes cluster which is configured in the **config.json** config file

```
bin/kube_auth

1) gke_cluster_1
2) gke_cluster_2
3) aws_cluster_1
4) minikube

4
Switching to minikube cluster
Looking up authentication for minikube
Cluster-name: minikube
Standalone authentication (not on GCE)
Switched to context "minikube".
```

Passing the config key of the required cluster will bypass the selection process and log directly into the cluster

```
bin/kube_auth minikube

Switching to minikube cluster
Looking up authentication for minikube
Cluster-name: minikube
Standalone authentication (not on GCE)
Switched to context "minikube".
```


### docker-auth

**docker-auth** is used to login and configure docker to push images required for Kubernetes deployments

```
bin/docker-auth

1) channels_production
2) channels_staging
3) oneshot
4) minikube
4
Configuring docker for use with minikube
Looking up authentication for minikube
Cluster-name: minikube
Configuring minikube local docker instance for images...
```

Passing the config key directly bypasses the selection process

```
bin/docker-auth minikube

Configuring docker for use with minikube
Looking up authentication for minikube
Cluster-name: minikube
Configuring minikube local docker instance for images...
```

## Config

Config is done in the **config.json** file.

The format of the file is

```
{
    //GKE cluster config
    "gke-cluster-1": {
        "name": "gke-cluster-1",                 //required key
        "platform": "gcloud"                     //required key: [gcloud, aws, standalone, minikube]
        "auth": {                                //required for gcloud, aws, standalone
            "cluster_name": "gke-cluster-name",
            "project_id": "google-project-id",
            "zone": "google-cluster-zone",
            "key_file": "key.json"
        }
    },

    //AWS
    "aws-c1": {
        //
    },

    "standalone-c1": {
        //
    },

    //Minikube
    "minikube": {
        "name": "minikube",
        "platform": "minikube"
    }
}
```
