{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage {
  pname = "std2";
  version = "unstable-2023-07-09";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "2d5594b40585ecae60ce5175bee68cc8b3085ee6";
    hash = "sha256-phGIWow7PGOtS1Pre1Gz0Xg6izGp6BiUTmze5jI/BwY=";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
