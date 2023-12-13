{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, poetry-dynamic-versioning
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.7.0"; # read before updating past 1.7.0 https://github.com/sbrunner/sphinx-prompt/issues/398
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    rev = "refs/tags/${version}";
    hash = "sha256-/XxUSsW8Bowks7P+d6iTlklyMIfTb2otXva/VtRVAkM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"poetry-plugin-tweak-dependencies-version", ' ""
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = [ sphinx ];

  meta = with lib; {
    description = "A sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
