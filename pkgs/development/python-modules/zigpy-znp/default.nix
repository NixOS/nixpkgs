{ lib
, async-timeout
, asynctest
, buildPythonPackage
, coloredlogs
, fetchFromGitHub
, fetchpatch
, jsonschema
, pyserial
, pyserial-asyncio
, pytest-asyncio
, pytest-mock
, pytest-timeout
, pytestCheckHook
, pythonOlder
, voluptuous
, zigpy
}:

buildPythonPackage rec {
  pname = "zigpy-znp";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "152d803jfrvkj4namni41fnbbnq85wd7zsqjhmkwrrmn2gvqjiln";
  };

  patches = [
    (fetchpatch {
      # Fixes tests/application/test_joining.py::test_new_device_join_and_bind_complex[FormedLaunchpadCC26X2R1]
      url = "https://github.com/zigpy/zigpy-znp/commit/582cffb68fdf0c5bc14d55efca2a683222d7fed7.patch";
      sha256 = "0qsfziqqjnnf21gdqv3wwk50vni46i0h1liw5ysq641yjfnas9az";
    })
  ];

  propagatedBuildInputs = [
    async-timeout
    coloredlogs
    jsonschema
    pyserial
    pyserial-asyncio
    voluptuous
    zigpy
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ]  ++ lib.optionals (pythonOlder "3.8") [
    asynctest
  ];

  pythonImportsCheck = [ "zigpy_znp" ];

  meta = with lib; {
    description = "Python library for zigpy which communicates with TI ZNP radios";
    homepage = "https://github.com/zigpy/zigpy-znp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    platforms = platforms.linux;
  };
}
