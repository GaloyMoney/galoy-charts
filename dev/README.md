# Charts dev setup

Intended as a local environment to test changes to the charts. Not as a dev backend for the mobile app.
Currently successfully brings up charts - no guarantee that everything is working as in prod, but enough to do some refactorings or stuff like that.

## Dependencies

### Docker
* choose the install method for your system https://docs.docker.com/desktop/

### Nix package manager
* recommended install method using https://github.com/DeterminateSystems/nix-installer
  ```
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  ```

### direnv >= 2.30.0
* recommended install method from https://direnv.net/docs/installation.html:
  ```
  curl -sfL https://direnv.net/install.sh | bash
  echo "eval \"\$(direnv hook bash)\"" >> ~/.bashrc
  source ~/.bashrc
  ```

## Regtest
* run in the `dev` folder:
  ```
  direnv allow
  make create-cluster
  tilt up
  ```

## Smoketests
### run the automated run-galoy-smoketest used in github actions
  ```
  make run-galoy-smoketest
  ```
### to test manually:

* forward the galoy-oathkeeper-proxy
  ```
  kubectl -n galoy-dev-galoy port-forward  svc/galoy-oathkeeper-proxy 4455:4455
  ```
* run the smoketest from another window (examples from the [galoy-smoketest.sh](/ci/tasks/galoy-smoketest.sh)):
  ```
  host=localhost
  port=4455
  phone='+59981730222'
  code='111111'

  # apollo-playground-ui
  curl -LksSf "${host}:${port}/graphql" \
    -H 'Accept-Encoding: gzip, deflate, br' -H 'Content-Type: application/json' \
    -H 'Accept: application/json' -H 'Connection: keep-alive' -H 'DNT: 1' \
    -H 'Origin: ${host}:${port}' --data-binary \
    '{"query":"query btcPrice {\n btcPrice {\n base\n currencyUnit\n formattedAmount\n offset\n }\n }","variables":{}}'

  # galoy-backend auth
  curl -LksSf "${host}:${port}/graphql" -H 'Content-Type: application/json' \
    -H 'Accept: application/json' --data-binary \
    "{\"query\":\"mutation login(\$input: UserLoginInput\!) { userLogin(input: \$input) { authToken } }\",\"variables\":{\"input\":{\"phone\":\"${phone}\",\"code\":\"${code}\"}}}"
  # admin-backend
  curl -LksSf  "${host}:${port}/admin/graphql" \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' --data-binary \
    "{\"query\":\"mutation login(\$input: UserLoginInput\!) { userLogin(input: \$input) { authToken } }\",\"variables\":{\"input\":{\"phone\":\"${phone}\",\"code\":\"${code}\"}}}" \
  ```
##