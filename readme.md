# JumpBox

## Usage

```bash
ssh -J root@jumpbox user@destination-host
```

## Configuration

The container can be configured through the following environment variables:

- `SSH_PORT` change the default ssh port (default is 22)
- `SSH_KEY_SEPARATOR` change the public key separator (default is comma)
- `SSH_PUB_KEY` set your ssh public key so that you can connect to this container (you can set multiple public keys separated by the character defined in the `SSH_KEY_SEPARATOR` environment variable)

## Deployment examples examples

### Start container using docker cli

```bash
docker run --rm -p 2122:22 -e SSH_PORT=22 -e SSH_PUB_KEY="your-ssh-public-key" --name jumpbox tinslice/jumpbox
```

Make sure that the public key does not have new lines.

### Deploy as a Kubernetes pod

Create the `jumpbox.yml` Kubernetes configuration

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: jumpbox
  labels:
    app: jumpbox
spec:
  containers:
  - name: jumpbox
    ports:
      - protocol: TCP
        containerPort: 22
    env:
    - name: SSH_PUB_KEY
      value: "your public key"
    image: tinslice/jumpbox
    imagePullPolicy: Always
    resources:
      requests:
        cpu: "200m"
        memory: "200Mi"
      limits:
        cpu: "200m"
        memory: "200Mi"
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  terminationGracePeriodSeconds: 2

---

apiVersion: v1
kind: Service
metadata:
  name: jumpbox
spec:
  selector:
    app: jumpbox
  ports:
  - port: 2122
    targetPort: 22
  type: LoadBalancer
```

Deploy jumpbox in the Kubernetes cluster

```bash
kubectl apply -f jumpbox.yml
```