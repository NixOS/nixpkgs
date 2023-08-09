{ lib
, buildPythonPackage
, fetchPypi
, pbr
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-apidoc";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cpv1ks97fdV8TAV5T3MtwCYScnXXhcKlSUUh/d53P7k=";
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

  meta = with lib; {
    description = "Sphinx extension for running sphinx-apidoc on each build";
    homepage = "https://github.com/sphinx-contrib/apidoc";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
