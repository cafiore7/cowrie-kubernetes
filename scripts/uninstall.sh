#!/bin/bash

NAMESPACE="cowrie-stack"

echo "🧨 Uninstalling Helm releases..."
helm uninstall cowrie -n $NAMESPACE || true
helm uninstall alloy -n $NAMESPACE || true
helm uninstall grafana -n $NAMESPACE || true
helm uninstall loki -n $NAMESPACE || true

echo "🧹 Deleting persistent volume claims and configmaps..."
kubectl delete pvc --all -n $NAMESPACE || true
kubectl delete configmap --all -n $NAMESPACE || true

echo "🗑️ Deleting namespace..."
kubectl delete namespace $NAMESPACE || true

echo "✅ Uninstall complete!"
