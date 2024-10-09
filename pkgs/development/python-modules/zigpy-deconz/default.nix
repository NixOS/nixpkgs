{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pyserial,
  pyserial-asyncio,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zigpy,
}:

buildPythonPackage rec {
  pname = "zigpy-deconz";
  version = "0.23.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-z/QulOkvkV/1Z+M7EfzdfGvrrtkapYcvfz+3AijR46k=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/zigpy/zigpy-deconz/commit/86fdcd6be824f12ce3bf88b40217a6224cbf5a89.patch";
      hash = "sha256-iqpTSJPBMSBZXg5EVXXupxIFRsGCNuxU/oNHZ2VT0Jc=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools-git-versioning<2"' "" \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
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
    changelog = "https://github.com/zigpy/zigpy-deconz/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
