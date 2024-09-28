{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  vapoursynth,
  vstools,
  vspyplugin,
  vsexprtools,
  vs-removegrain,
  rgsf,
  akarin-expr,
}:

buildPythonPackage rec {
  pname = "vsrgtools";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-rgtools";
    rev = "refs/tags/v${version}";
    hash = "sha256-wTfCp3p0payk6qm7DMfB7gjzEmI5/aYNuWs1upTnDXc=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    vs-removegrain
    rgsf
    akarin-expr
  ];

  dependencies = [
    vapoursynth
    vstools
    vspyplugin
    vsexprtools
  ];

  pythonImportsCheck = [
    "vsrgtools"
    "vsrgtools.aka_expr"
  ];

  doCheck = false; # no tests

  meta = {
    description = "RgTools and related functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-rgtools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
