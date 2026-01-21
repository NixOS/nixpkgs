{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gflanguages,
  num2words,
  protobuf,
  pytestCheckHook,
  pyyaml,
  setuptools-scm,
  setuptools,
  strictyaml,
  termcolor,
  ufo2ft,
  vharfbuzz,
  youseedee,
}:

buildPythonPackage rec {
  pname = "shaperglot";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    tag = "v${version}";
    hash = "sha256-Jh2/Rr7bIPFiblUZFS8KiQtMwmtMuOGCSV2w7LMCbq8=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=75.0.0" "setuptools"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shaperglot" ];

  meta = {
    description = "Tool to test OpenType fonts for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    changelog = "https://github.com/googlefonts/shaperglot/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
    mainProgram = "shaperglot";
  };
}
