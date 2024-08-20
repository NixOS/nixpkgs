{
  buildPythonApplication,
  colorclass,
  fetchPypi,
  fetchurl,
  installShellFiles,
  lib,
  linode-metadata,
  openapi3,
  packaging,
  pyyaml,
  requests,
  rich,
  setuptools,
  terminaltables,
}:

let
  hash = "sha256-IXltDBgabTBDw0y7IXgRGpAWVUyqeJI8EfxkZ5YuQrU=";
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.176.0";
  specHash = "sha256-P1E8Ga5ckrsw/CX0kxFef5fe8/p/pDCLuleX9wR5l48=";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    hash = specHash;
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.50.0";
  pyproject = true;

  src = fetchPypi {
    pname = "linode_cli";
    inherit version;
    hash = "sha256-OCnO7Bf2tDnC4g7kYS0WFlV9plAS25GbzRO6mpDYYxk=";
  };

  patches = [ ./remove-update-check.patch ];

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version = get_version()" "version='${version}',"
  '';

  postConfigure = ''
    python3 -m linodecli bake ${spec} --skip-config
    cp data-3 linodecli/
    echo "${version}" > baked_version
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    colorclass
    linode-metadata
    pyyaml
    requests
    setuptools
    terminaltables
    rich
    openapi3
    packaging
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linode-cli --skip-config --version | grep ${version} > /dev/null
  '';

  postInstall = ''
    for shell in bash fish; do
      installShellCompletion --cmd linode-cli \
        --$shell <($out/bin/linode-cli --skip-config completion $shell)
      done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Linode Command Line Interface";
    changelog = "https://github.com/linode/linode-cli/releases/tag/v${version}";
    downloadPage = "https://pypi.org/project/linode-cli";
    homepage = "https://github.com/linode/linode-cli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ryantm
      techknowlogick
    ];
    mainProgram = "linode-cli";
  };
}
