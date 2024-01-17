#!/bin/bash

APP_VERSION="1.12.7"

curl -LO https://github.com/jetstack/cert-manager/releases/download/v${APP_VERSION}/cert-manager.yaml

mv cert-manager.yaml cert-manager-${APP_VERSION}.yaml