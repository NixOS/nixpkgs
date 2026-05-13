{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  replaceVars,
  setuptools,
}:

buildPythonPackage rec {
  pname = "setuptools-git";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msabramo";
    repo = "setuptools-git";
    tag = version;
    hash = "sha256-dbQ15y62nanuWgh2puLYSio391Ja3SF+HrafvTBVNbk=";
  };

  patches = [
    (replaceVars ./hardcode-git-path.patch {
      git = lib.getExe gitMinimal;
    })
  ];

  build-system = [ setuptools ];

  doCheck = false;

  meta = {
    description = "Setuptools revision control system plugin for Git";
    homepage = "https://github.com/msabramo/setuptools-git";
    license = lib.licenses.bsd3;
  };
}
