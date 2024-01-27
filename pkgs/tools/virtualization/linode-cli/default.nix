{ lib
, fetchFromGitHub
, fetchurl
, buildPythonApplication
, colorclass
, installShellFiles
, pyyaml
, requests
, setuptools
, terminaltables
, rich
, openapi3
, packaging
}:

let
  hash = "sha256-J0L+FTVzYuAqTDOwpoH12lQr03UNo5dsQpd/iUKR40Q=";
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.166.0";
  specHash = "sha256-rUwKQt3y/ALZUoW3eJiiIDJYLQpUHO7Abm0h09ra02g=";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    hash = specHash;
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.45.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = "v${version}";
    inherit hash;
  };

  patches = [
    ./remove-update-check.patch
  ];

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version = get_version()" "version='${version}',"
  '';

  propagatedBuildInputs = [
    colorclass
    pyyaml
    requests
    setuptools
    terminaltables
    rich
    openapi3
    packaging
  ];

  postConfigure = ''
    python3 -m linodecli bake ${spec} --skip-config
    cp data-3 linodecli/
    echo "${version}" > baked_version
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linode-cli --skip-config --version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd linode-cli --bash <($out/bin/linode-cli --skip-config completion bash)
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    mainProgram = "linode-cli";
    description = "The Linode Command Line Interface";
    homepage = "https://github.com/linode/linode-cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryantm techknowlogick ];
  };
}
