{ lib
, buildPythonPackage
, fetchPypi
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-apidoc";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/lnRWIJHKqk8Jzevvepr7bNM41y9NKpJR5CfXfFQCq0=";
  };

  postPatch = ''
    # break infite recursion, remove pytest 4 requirement
    rm test-requirements.txt requirements.txt
  '';

  propagatedBuildInputs = [
    pbr
  ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension for running sphinx-apidoc on each build";
    homepage = "https://github.com/sphinx-contrib/apidoc";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
