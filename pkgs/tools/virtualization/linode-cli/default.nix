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
  sha256 = "1fv53wikx745kci86xrsq9kfsgv0a65srhywdw32cab1wywwpn2z";
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.132.0";
  specSha256 = "0r0l23bvaj406xam7hglfx637cxja3g2vqdqx3x0ag7jfhg0s3k5";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    sha256 = specSha256;
  };

in

buildPythonApplication rec {
  pname = "linode-cli";
  version = "5.22.0";

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
