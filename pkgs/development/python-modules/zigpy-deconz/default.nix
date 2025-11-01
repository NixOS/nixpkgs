{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.25.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-deconz";
    tag = version;
    hash = "sha256-fzjfU8igoXssfJnN2wsl4Wa+vmI1TRQSITk8cAuhuCQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zigpy_deconz" ];

  meta = with lib; {
    description = "Library which communicates with Deconz radios for zigpy";
    homepage = "https://github.com/zigpy/zigpy-deconz";
    changelog = "https://github.com/zigpy/zigpy-deconz/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
