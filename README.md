# 🐻 Cowrie Kubernetes Honeypot Monitoring Stack

**THIS IS STILL A WORK IN PROGRESS**

A full-stack observability and honeypot monitoring system running on Kubernetes using:

- [`Cowrie`](https://github.com/cowrie/cowrie) – SSH/Telnet honeypot  
- [`Grafana`](https://grafana.com/) – Visualizations and dashboards  
- [`Loki`](https://grafana.com/oss/loki/) – Log aggregation  
- [`Alloy`](https://grafana.com/oss/alloy/) – Unified agent to forward Cowrie logs to Loki  
- [`Helm`](https://helm.sh/) – For deployment management  

---

## 📁 Project Structure

```bash
cowrie-kubernetes/
├── alloy/                   
│   └── config.alloy
├── charts/                  
│   └── cowrie/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── configmap.yaml
│           ├── deployment.yaml
│           ├── pvc.yaml
│           └── service.yaml
├── scripts/                
│   ├── install.sh
│   └── uninstall.sh
├── LICENSE
└── README.md
```

---

## 🚀 Quick Start

### 1. Prerequisites

Make sure you have:

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [k9s (optional)](https://k9scli.io/) – CLI Kubernetes UI

### 2. Start Minikube

```bash
minikube start
```

### 3. Install Everything

```bash
./scripts/install.sh
```

This will:

- Create the `cowrie-stack` namespace  
- Install Loki, Grafana, Alloy (log agent), and Cowrie via Helm

### 4. Access Grafana

```bash
kubectl port-forward -n cowrie-stack svc/grafana 3000:80
```

Then open [http://localhost:3000](http://localhost:3000)

> **Default credentials**  
> Username: `admin`  
> Password: Run the following to get it:

```bash
kubectl get secret -n cowrie-stack grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

---

## 🔐 How It Works

- Cowrie writes logs to `/cowrie/var/log/cowrie.json`
- Alloy tails this file and sends logs to Loki
- Loki stores the logs
- Grafana queries Loki and displays them

---

## 🧹 Uninstall

```bash
./scripts/uninstall.sh
```

This will remove:

- The `cowrie-stack` namespace  
- All Helm releases and their Kubernetes resources

---

## 🛠️ Customization

### 🔧 Cowrie Configuration

Edit `charts/cowrie/templates/configmap.yaml` to update Cowrie behavior (e.g., port or logging).

### 📝 Alloy Configuration

The file `alloy/config.alloy` defines which logs are collected and where they are sent.

### 📊 Dashboards

You can pre-provision dashboards or use the UI to create and save them in Grafana.

---

## 📚 Resources

- [Cowrie Documentation](https://cowrie.readthedocs.io/en/latest/)
- [Grafana Loki Docs](https://grafana.com/docs/loki/latest/)
- [Grafana Alloy Docs](https://grafana.com/docs/alloy/latest/)
- [Helm Docs](https://helm.sh/docs/)

---

## 💡 Ideas to Extend

- Export alerts from Grafana when Cowrie is triggered
- Store logs to S3 or persistent disk
- Monitor other honeypots or containers
- Add Prometheus and node-exporter for cluster metrics
- Ship logs to external SIEMs like Splunk or Elastic

---

## 🧑‍💻 License

MIT License. See [LICENSE](LICENSE).

