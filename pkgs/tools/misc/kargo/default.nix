{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "0.4.6";
  name = "kargo-${version}";

  src = fetchurl {
    url = "mirror://pypi/k/kargo/${name}.tar.gz";
    sha256 = "1sm721c3d4scpc1gj2j3qwssr6jjvw6aq3p7ipvhbd9ywmm9dd7b";
  };

  doCheck = false;

  propagatedBuildInputs = with python2Packages; [
    ansible2
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

  meta = with stdenv.lib; {
    homepage = https://github.com/kubespray/kargo-cli;
    description = "A tool helps to deploy a kubernetes cluster with Ansible.";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      jgeerds
    ];
  };
}
