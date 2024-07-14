{ lib, fetchurl, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  version = "0.4.8";
  pname = "kargo";

  src = fetchurl {
    url = "mirror://pypi/k/kargo/${pname}-${version}.tar.gz";
    hash = "sha256-YzWT18cMnUFScVUsblP6C1RTyvl+gBz1fekp+mreA8c=";
  };

  propagatedBuildInputs = [
    ansible-core
    boto
    cffi
    cryptography
    libcloud
    markupsafe
    netaddr
    pyasn1
    requests
    setuptools
  ];

  checkPhase = ''
    HOME=$TMPDIR $out/bin/kargo -v
  '';

  meta = with lib; {
    homepage = "https://github.com/kubespray/kargo-cli";
    description = "Tool helps to deploy a kubernetes cluster with Ansible";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    mainProgram = "kargo";
  };
}
