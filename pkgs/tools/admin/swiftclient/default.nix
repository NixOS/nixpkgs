{ lib, buildPythonApplication, fetchPypi, requests, six, pbr, setuptools }:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3972f8b1986e60ea786ad01697e6882f331209ae947ef8b795531940f1e0732b";
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
