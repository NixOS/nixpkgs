{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "setuptools-scm-git-archive";
  version = "1.1";

  src = fetchPypi {
    inherit version;
    pname = "setuptools_scm_git_archive";
    sha256 = "6026f61089b73fa1b5ee737e95314f41cb512609b393530385ed281d0b46c062";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];

  doCheck = false;
  pythonImportsCheck = [ "setuptools_scm_git_archive" ];

  meta = with stdenv.lib; {
    description = "setuptools_scm plugin for git archives";
    homepage = "https://github.com/Changaco/setuptools_scm_git_archive";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
