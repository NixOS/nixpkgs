{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gflanguages,
  num2words,
  protobuf,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  strictyaml,
  termcolor,
  ufo2ft,
  vharfbuzz,
  youseedee,
}:

buildPythonPackage rec {
  pname = "shaperglot";
  version = "0.5.0";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    rev = "refs/tags/v${version}";
    hash = "sha256-jmYB1tsMMpFs0X/FW3z9el2nFr8De2jR1dO658w7U4Q=";
  };

  pyproject = true;

  dependencies = [
    gflanguages
    num2words
    protobuf
    pyyaml
    strictyaml
    termcolor
    ufo2ft
    vharfbuzz
    youseedee
  ];
  build-system = [
    setuptools
    setuptools-scm
  ];

  doCheck = true;
  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tool to test OpenType fonts for language support";
    mainProgram = "shaperglot";
    homepage = "https://github.com/googlefonts/shaperglot";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
