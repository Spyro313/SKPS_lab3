az account set --subscription a018ab7e-82bc-4d3b-8940-6ab1d40674ff
az aks get-credentials --resource-group lab3_conf1 --name wus_lab3

# szybki check
kubectl get nodes # powinny wyjść dwa nody na początku
# kubectl get pods #No resources found in default namespace

git clone https://github.com/spring-petclinic/spring-petclinic-cloud.git
# TO DO ręcznie: podmianka repliki na 2, w skryptach yaml w k8s dla vets, visits, customers
# podmianka CPU wszędzie z 2000m na 1000m, dla wszystkich czterech yaml 
# ewentualnie dodanie anty-affinity - żeby dążył do nie robienia dwa razy na tym samym nodzie, ale działa też bez

cd spring-petclinic-cloud/

kubectl apply -f k8s/init-namespace # namespace/spring-petclinic created
kubectl apply -f k8s/init-services # tworzy serwisy

kubectl get svc -n spring-petclinic # verify the services are available

helm repo add bitnami https://charts.bitnami.com/bitnami  # "bitnami" has been added to your repositories

helm repo update 
helm search repo bitnami/mysql # sprawdzenie jaka wersja mysql jest dostępna w heml, na repo już stara, tutaj 9.16.0

helm install vets-db-mysql bitnami/mysql --namespace spring-petclinic --version 9.16.0 --set auth.database=service_instance_db
helm install visits-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.16.0 --set auth.database=service_instance_db
helm install customers-db-mysql bitnami/mysql --namespace spring-petclinic  --version 9.16.0 --set auth.database=service_instance_db

export REPOSITORY_PREFIX=springcommunity

./scripts/deployToKubernetes.sh

kubectl get pods -n spring-petclinic  # weryfikacja podów

kubectl get svc -n spring-petclinic api-gateway # sprawdzenie IP na którym działa petclinic

# PRZYDATNE KOMENDY
# kubectl get pods -o wide -n spring-petclinic # żeby pokazać na których nodach
# kubectl delete pod moj-pod -n spring-petclinic
# kubectl logs api-gateway-6bd4bfb485-5cks4 -n spring-petclinic #przykładowy log
# kubectl describe pod api-gateway-6bd4bfb485-5cks4 -n spring-petclinic
