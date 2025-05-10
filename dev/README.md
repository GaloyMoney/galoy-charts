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
