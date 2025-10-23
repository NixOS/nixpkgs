{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyserial-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.25.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-deconz";
    tag = version;
    hash = "sha256-hFjp/QE7VGJrL84M/M5HfdNnGEXUBnjM2i7/0+Y6O0I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
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
