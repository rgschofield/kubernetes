# IKS Kubemark
### Requirements:
* IBM Cloud CLI (Download here: https://console.bluemix.net/docs/cli/index.html#overview)
* IBM Cloud Account
* Ability to run bash code
* Docker (Download here: https://www.docker.com/get-docker)
### Steps to run kubemark:
1. Clone this repository: git@github.com:brandondr96/kubernetes.git
2. Switch to the branch "stat-tester".
3. Run ```bash iks-start-kubemark.sh```. This script will create all necessary resources, clusters, and namespaces for kubemark to run.
4. Respond to the prompts as desired.

*__Note__: If you want to use existing clusters, they must be created beforehand. When prompted, enter the paths for these clusters.*
### Steps to stop kubemark:
1. Run ```bash iks-stop-kubemark.sh```.
2. Check to ensure the clusters are down, using commands such as ```bx cs clusters```.
