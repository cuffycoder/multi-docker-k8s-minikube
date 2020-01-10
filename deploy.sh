#build the containers and push to DockerHub
docker build -t cuffycoder/multi-client:latest -t cuffycoder/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t cuffycoder/multi-server:latest -t cuffycoder/multi-server:$SHA -f ./server/Dockerfile ./server 
docker build -t cuffycoder/multi-worker:latest -t cuffycoder/multi-worker:$SHA -f ./worker/Dockerfile ./worker 
docker push cuffycoder/multi-client:latest
docker push cuffycoder/multi-server:latest
docker push cuffycoder/multi-worker:latest

docker push cuffycoder/multi-client:$SHA
docker push cuffycoder/multi-server:$SHA
docker push cuffycoder/multi-worker:$SHA

# apply the configs to k8s
kubectl apply -f k8s

# make sure kubernetes updates the image using the latest
kubectl set image deployments/server-deployment server=cuffycoder/multi-server:$SHA
kubectl set image deployments/client-deployment client=cuffycoder/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=cuffycoder/multi-worker:$SHA