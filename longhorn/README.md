`USER=<USERNAME_HERE>; PASSWORD=<PASSWORD_HERE>; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth`


`kubectl -n longhorn-system create secret generic basic-auth --from-file=auth` 