{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "0.4.8";
  pname = "kargo";

  src = fetchurl {
    url = "mirror://pypi/k/kargo/${pname}-${version}.tar.gz";
    sha256 = "1iq3vrmglag9gpsir03yz7556m0bz99nwb2mf594378cqzbr6db3";
  };

  doCheck = false;

  propagatedBuildInputs = with python2Packages; [
    ansible
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
    homepage = "https://github.com/kubespray/kargo-cli";
    description = "A tool helps to deploy a kubernetes cluster with Ansible.";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
    ];
  };
}
