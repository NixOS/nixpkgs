{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gflanguages,
  num2words,
  protobuf,
  pytestCheckHook,
  pythonOlder,
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
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "shaperglot";
    tag = "v${version}";
    hash = "sha256-Maslpm/PriKD14pJLby5A4S5MrFCWpBuWBrJ6CBAkS8=";
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

  meta = with lib; {
    description = "Tool to test OpenType fonts for language support";
    homepage = "https://github.com/googlefonts/shaperglot";
    changelog = "https://github.com/googlefonts/shaperglot/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
    mainProgram = "shaperglot";
  };
}
