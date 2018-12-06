{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "setuptools-git";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "047d7595546635edebef226bc566579d422ccc48a8a91c7d32d8bd174f68f831";
  };

  propagatedBuildInputs = [ pkgs.git ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Setuptools revision control system plugin for Git";
    homepage = https://pypi.python.org/pypi/setuptools-git;
    license = licenses.bsd3;
  };

}
