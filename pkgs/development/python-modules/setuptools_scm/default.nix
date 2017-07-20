{ stdenv, buildPythonPackage, fetchPypi, pip }:
buildPythonPackage rec {
  pname = "setuptools_scm";
  name = "${pname}-${version}";
  version = "1.15.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pzvfmx8s20yrgkgwfbxaspz2x1g38qv61jpm0ns91lrb22ldas9";
  };

  buildInputs = [ pip ];

  # Seems to fail due to chroot and would cause circular dependency
  # with pytest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/pypa/setuptools_scm/;
    description = "Handles managing your python package versions in scm metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ jgeerds ];
  };
}
