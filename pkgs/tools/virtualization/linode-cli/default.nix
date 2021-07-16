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
}:

let
  specVersion = "4.98.0"; # Version taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    sha256 = "sha256-3SweDMfgq2+QQIdeb6EjL7A2Grd/7KQzsbMNZKPtXts=";
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = version;
    sha256 = "sha256-hljvcYtck89Lzje0XgnvYqh+jebOEOFnOkgEnGZJm0o=";
  };

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version=get_version()," "version='${version}',"
  '';

  propagatedBuildInputs = [
    colorclass
    pyyaml
    requests
    setuptools
    terminaltables
  ];

  postConfigure = ''
    python3 -m linodecli bake ${spec} --skip-config
    cp data-3 linodecli/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linode-cli --skip-config --version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd linode-cli --bash <($out/bin/linode-cli --skip-config completion bash)
  '';

  meta = with lib; {
    description = "The Linode Command Line Interface";
    homepage = "https://github.com/linode/linode-cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryantm superherointj ];
  };
}
