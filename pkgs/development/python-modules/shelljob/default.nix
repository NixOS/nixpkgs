{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "shelljob";
  version = "0.6.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mortoray";
    repo = "shelljob";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UJ8DcQaYUiZMZ4hh2juQ/HUwY4LtH6GDjZWioNnfBmw=";
  };

  # setup.py version value in tag is invalid, see https://github.com/mortoray/shelljob/blob/v0.6.3/setup.py#L20
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '0.6.2' '${finalAttrs.version}'
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "shelljob" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires external resources (hello.txt, internet access via curl, fhs)
  disabledTests = [
    "test_basic"
    "test_unicode_group"
    "test_example"
    "test_encoding"
  ];

  meta = {
    description = "Python process and file system module";
    homepage = "https://github.com/mortoray/shelljob";
    changelog = "https://github.com/mortoray/shelljob/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
