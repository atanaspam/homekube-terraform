# Certificate Authority

In order to be able to generate users locally without having to log in to your kubernetes cluster you want to have your own Certificate Authority. This way you can use that to create intermediate CAs and pass those to your cluster. Since you control those CAs you can essentialy create more certificates for any new users yourself.

## Prerequisites

You need to have your own Root CA. You can create that using the steps below.

```bash
mkdir $HOME/root-ca
cd root-ca
cat << EOF > root-ca-config.json
{
    "signing": {
        "profiles": {
            "intermediate": {
                "usages": [
                    "signature",
                    "digital-signature",
                    "cert sign",
                    "crl sign"
                ],
                "expiry": "26280h",
                "ca_constraint": {
                    "is_ca": true,
                    "max_path_len": 0,
                    "max_path_len_zero": true
                }
            }
        }
    }
}
EOF
cat << EOF > root-ca-csr.json
{
    "CN": "my-root-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "87600h"
    }
}
EOF
cfssl genkey -initca root-ca-csr.json | cfssljson -bare ca
```

## Create your kubernetes intermediate CAs

Now you can create the Certificate Authorty that you will send to your kubernetes cluster so that it can generate all the certificates it needs

### Kubernetes general CA

From the repository root folder run the following commands:

```bash
cd ca
mkdir kubernetes-ca
cd kubernetes-ca
cat << EOF > kubernetes-ca-csr.json
{
    "CN": "kubernetes-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca kubernetes-ca-csr.json | cfssljson -bare kubernetes-ca
cfssl sign -ca $HOME/root-ca/ca.pem -ca-key $HOME/root-ca/ca-key.pem -config $HOME/root-ca/root-ca-config.json -profile intermediate kubernetes-ca.csr | cfssljson -bare kubernetes-ca
cfssl print-defaults config kubernetes-ca-config.json
cd ..
```

### Kubernetes Front Proxy CA

```bash
mkdir kubernetes-front-proxy-ca
cd kubernetes-front-proxy-ca
cat << EOF > kubernetes-front-proxy-ca-csr.json
{
    "CN": "kubernetes-front-proxy-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca kubernetes-front-proxy-ca-csr.json | cfssljson -bare kubernetes-front-proxy-ca
cfssl sign -ca $HOME/root-ca/ca.pem -ca-key $HOME/root-ca/ca-key.pem -config $HOME/root-ca/root-ca-config.json -profile intermediate kubernetes-front-proxy-ca.csr | cfssljson -bare kubernetes-front-proxy-ca
cfssl print-defaults config kubernetes-front-proxy-ca-config.json
cd ..
```

### etcd CA

```bash
mkdir etcd-ca
cd etcd-ca
cat << EOF > etcd-ca-config.json
{
    "signing": {
        "profiles": {
            "server": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "8700h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF
cat << EOF > etcd-ca-csr.json
{
    "CN": "etcd-ca",
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "ca": {
        "expiry": "26280h"
    }
}
EOF
cfssl genkey -initca etcd-ca-csr.json | cfssljson -bare etcd-ca
cfssl sign -ca $HOME/root-ca/ca.pem -ca-key $HOME/root-ca/ca-key.pem -config $HOME/root-ca/root-ca-config.json -profile intermediate etcd-ca.csr | cfssljson -bare etcd-ca
cd ..
```
