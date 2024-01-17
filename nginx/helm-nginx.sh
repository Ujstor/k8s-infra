#!/bin/bash

CHART_VERSION="4.9.0"
APP_VERSION="1.9.5"

helm template ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--version ${CHART_VERSION} \
--namespace ingress-nginx \
> nginx-ingress.${APP_VERSION}.yaml
