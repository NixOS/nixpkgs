{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "strenum";
  version = "0.4.15";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "irgeek";
    repo = "StrEnum";
    tag = "v${version}";
    hash = "sha256-LrDLIWiV/zIbl7CwKh7DAy4LoLyY7+hfUu8nqduclnA=";
  };

  patches = [
    # Replace SafeConfigParser and readfp, https://github.com/milanmeu/aioaseko/pull/6
    (fetchpatch {
      name = "replace-safeconfigparser.patch";
      url = "https://github.com/irgeek/StrEnum/commit/896bef1b7e4a50c8b53d90c8d2fb5c0164f08ecd.patch";
      hash = "sha256-dmmEzhy17huclo1wOubpBUDc2L7vqEU5b/6a5loM47A=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
    substituteInPlace pytest.ini \
      --replace " --cov=strenum --cov-report term-missing --black --pylint" ""
  '';

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "strenum" ];

  meta = with lib; {
    description = "Module for enum that inherits from str";
    homepage = "https://github.com/irgeek/StrEnum";
    changelog = "https://github.com/irgeek/StrEnum/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
