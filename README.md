# kubernetes-management-tools

Managing multiple Kubernetes deployments across many cloud providers can become a bit clumbersome
so I decided to write a few tools to ease with this pain.

Currently this tool will work with Kubernetes clusters on the following platforms:

* Google cloud engine
* AWS
* Minikube (local development)
* Generic certificate connected clusters

## Tools

### kube-auth

**kube-auth** is used to login to a kubernetes cluster which is configured in the **config.json** config file

```
kube_auth

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
kube_auth minikube

Switching to minikube cluster
Looking up authentication for minikube
Cluster-name: minikube
Standalone authentication (not on GCE)
Switched to context "minikube".
```


### docker-auth

**docker-auth** is used to login and configure docker to push images required for Kubernetes deployments

```
docker-auth

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
docker-auth minikube

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
