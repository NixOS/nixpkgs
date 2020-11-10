{ lib, buildPythonApplication, fetchPypi, requests, six, pbr, setuptools }:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0176b17aa14cc2ef82a327dc70b66af670bdb39dcf836896f81269db376932ea";
  };

  propagatedBuildInputs = [ requests six pbr setuptools ];

  # For the tests the following requirements are needed:
  # https://github.com/openstack/python-swiftclient/blob/master/test-requirements.txt
  #
  # The ones missing in nixpkgs (currently) are:
  # - hacking
  # - keystoneauth
  # - oslosphinx
  # - stestr
  # - reno
  # - openstackdocstheme
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    license = licenses.asl20;
    maintainers = with maintainers; [ c0deaddict ];
  };
}
