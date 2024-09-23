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
    sha256 = "1fv7g1szyjykja9mzax2w4js7jm2z7wwzgnr5dqrsdi84j6v8qlx";
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
