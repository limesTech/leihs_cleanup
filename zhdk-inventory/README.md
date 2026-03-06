The ZHdK Leihs Inventory for Development, Test and Staging Hosts
================================================================

This inventory is included within the leihs source code because deployment to
the specified hosts and environment is part of the developlentcycle at the ZHdK
Leihs Team.

The inventory for production at the ZHdK can be found here:
https://github.com/zhdk/leihs-server-inventory


Deployment
----------

Our CI has predefined jobs to run a deploy. This is the straight forward and
transparent way to deploy.

To deploy from localhost on `tom`:

    HOST=tom ./bin/deploy




Secrets Encryption
------------------

Some secrets are required to deploy to the dev, staging and test environments.
These are protected via https://github.com/elasticdog/transcrypt.

### Important Commands

To list encrypted files run `git ls-crypt`.

To unlock the encrypted files run ./bin/unlock.

Unlocking is rarely necessary. Some cases include deployments to a ZHdK Server,
or changing ZHdK Secrets.

Run `./bin/transcrypt --flush-credentials` to bring the files back to their encrypted state.

### Key Rollover

See https://github.com/elasticdog/transcrypt?tab=readme-ov-file#rekeying for key rollover.

We store the symmetric key via gpg in the project. After a rollover:

1. put the unencrypted key in `.transcrypt_key.txt`,
2. run `./bin/encrypt-transcrypt-key`,
3. remove `.transcrypt_key.txt`, and
4. commit.

