{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchurl
, terminaltables
, colorclass
, requests
, pyyaml
, setuptools
, installShellFiles
}:

let

  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v4.89.0/openapi.yaml";
    sha256 = "sha256-R7Dmq8ifGEjh47ftuoGrbymYBsPCj/ULz0j1OqJDcwY=";
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = version;
    sha256 = "sha256-zelopRaHaDCnbYA/y7dNMBh70g0+wuc6t9LH/VLaUIk=";
  };

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version=get_version()," "version='${version}',"
  '';

  propagatedBuildInputs = [
    terminaltables
    colorclass
    requests
    pyyaml
    setuptools
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
    homepage = "https://github.com/linode/linode-cli";
    description = "The Linode Command Line Interface";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryantm superherointj ];
  };

}
