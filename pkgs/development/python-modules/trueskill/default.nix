{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "trueskill";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nWK0jSQoNp1xK9m+z/n5osqjJeGiq1+TktNL/3V4Z7s=";
  };

  propagatedBuildInputs = [ six ];

  # Can't build distribute, see https://github.com/NixOS/nixpkgs/pull/49340
  doCheck = false;

  meta = with lib; {
    description = "Video game rating system";
    homepage = "https://trueskill.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
