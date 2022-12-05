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
  sha256 = "0lngwmb9j3nzwhkhq4r9sy82gwjry14lvjjgm8vfivbbakjdl7xp";
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.139.0";
  specSha256 = "1z050vm049gb8vynp34iz9jpxwbpmbf5vbs1jsirwqbfhr1skslz";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    sha256 = specSha256;
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.25.0";

  src = fetchFromGitHub {
    owner = "linode";
    repo = pname;
    rev = version;
    inherit sha256;
  };

  patches = [
    ./remove-update-check.patch
  ];

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "The Linode Command Line Interface";
    homepage = "https://github.com/linode/linode-cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryantm ];
  };
}
