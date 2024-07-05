```bash
source <(kubectl completion bash)
```

Add the following to your `.bashrc` file:


```bash
alias k='kubectl'
complete -F __start_kubectl k
```

```bash
source ~/.bashrc
```
