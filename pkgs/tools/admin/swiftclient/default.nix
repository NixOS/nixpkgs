{ lib, buildPythonApplication, fetchPypi, requests, six, pbr, setuptools }:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xx3v5kk8jp352rydy3jxndy1b9kl2zmkj1gi14fjxjc5r4rf82g";
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
