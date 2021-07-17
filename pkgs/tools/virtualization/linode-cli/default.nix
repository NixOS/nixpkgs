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
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.99.0";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    sha256 = "10z63a2clbiskdnmnyf4m8v2hgc4bdm703y7s2dpw0q09msx9aca";
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = version;
    sha256 = "sha256-AjO4h0PaE/QFwbwUVNoe98XOPZ24ct0mbLkua5/YsEA=";
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
