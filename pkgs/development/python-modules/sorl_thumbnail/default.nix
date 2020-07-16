{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "12.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66771521f3c0ed771e1ce8e1aaf1639ebff18f7f5a40cfd3083da8f0fe6c7c99";
  };

  nativeBuildInputs = [ setuptools_scm ];
  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://sorl-thumbnail.readthedocs.org/en/latest/";
    description = "Thumbnails for Django";
    license = licenses.bsd3;
  };

}
