#!/bin/bash

set -e

echo "🔧 Creating namespace..."
kubectl create namespace cowrie-stack || true

echo "🚀 Adding Grafana Helm repo..."
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "📦 Installing Loki..."
helm install loki grafana/loki-stack \
  --namespace cowrie-stack \
  --set promtail.enabled=false

echo "📦 Installing Grafana..."
helm install grafana grafana/grafana \
  --namespace cowrie-stack \
  --set adminUser=admin \
  --set adminPassword=admin \
  --set service.type=NodePort \
  --set service.nodePort=32000

echo "📦 Installing Alloy..."
helm install alloy grafana/alloy \
  --namespace cowrie-stack \
  --set configMap.create=true \
  --set-file configMap.config.alloy=../alloy/config.alloy

echo "📦 Installing Cowrie..."
helm install cowrie ../charts/cowrie --namespace cowrie-stack

echo "✅ Deployment complete! Access Grafana at http://<node-ip>:32000"
