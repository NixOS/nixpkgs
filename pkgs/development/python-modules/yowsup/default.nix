{
  lib,
  buildPythonPackage,
  pythonOlder,
  isPy3k,
  fetchFromGitHub,
  setuptools,
  appdirs,
  consonance,
  protobuf,
  python-axolotl,
  six,
  pyasyncore,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yowsup";
  version = "3.3.0";
  pyproject = true;

  # The Python 2.x support of this package is incompatible with `six==1.11`:
  # https://github.com/tgalal/yowsup/issues/2416#issuecomment-365113486
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "tgalal";
    repo = "yowsup";
    rev = "refs/tags/v${version}";
    sha256 = "1pz0r1gif15lhzdsam8gg3jm6zsskiv2yiwlhaif5rl7lv3p0v7q";
  };

  pythonRelaxDeps = true;
  pythonRemoveDeps = [ "argparse" ];

  env = {
    # make protobuf compatible with old versions
    # https://developers.google.com/protocol-buffers/docs/news/2022-05-06#python-updates
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [
    appdirs
    consonance
    protobuf
    python-axolotl
    six
  ] ++ lib.optionals (!pythonOlder "3.12") [ pyasyncore ];

  meta = {
    homepage = "https://github.com/tgalal/yowsup";
    description = "Python WhatsApp library";
    mainProgram = "yowsup-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
