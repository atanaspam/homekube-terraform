# Certificate Authority

In order to be able to generate users locally without having to log in to your kubernetes cluster you want to have your own Certificate Authority. This way you can use that to create intermediate CAs and pass those to your cluster. Since you control those CAs you can essentialy create more certificates for any new users yourself.

More details on setting up your own CA can be found [here](docs/ca.md).
