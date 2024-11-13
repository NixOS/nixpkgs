{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
  testers,
  vinput,
}:

buildPythonPackage rec {
  pname = "vinput";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xslendix";
    repo = "libvinput.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-86oNsbdw59zvxQvn05Q493mAoZdIBWUu/GtQvIJiEEY=";
  };

  postPatch = ''
    substituteInPlace "vinput/_binding.py" \
      --replace-fail  "dir_path = os.path.dirname(os.path.realpath(__file__))" "dir_path = "$out/""
  '';

  build-system = [
    setuptools
    wheel
  ];

  pythonImports = [
    "vinput"
  ];

  passthru = {
    tests.version = testers.testVersion { package = vinput; };
  };

  meta = {
    description = "Python bindings for libvinput";
    homepage = "https://github.com/xslendix/libvinput.py";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
