{ lib
, aiohttp
, aioresponses
, attrs
, buildPythonPackage
<<<<<<< HEAD
, defusedxml
, fetchFromGitHub
=======
, cached-property
, defusedxml
, fetchFromGitHub
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, freezegun
, httpx
, isodate
, lxml
, mock
, platformdirs
, pretend
, pytest-asyncio
, pytest-httpx
, pytestCheckHook
, pythonOlder
, pytz
, requests
, requests-toolbelt
, requests-file
, requests-mock
, xmlsec
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "4.2.1";
<<<<<<< HEAD
  format = "setuptools";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mvantellingen";
    repo = "python-zeep";
    rev = "refs/tags/${version}";
    hash = "sha256-8f6kS231gbaZ8qyE8BKMcbnZsm8o2+iBoTlQrs5X+jY=";
  };

  propagatedBuildInputs = [
    attrs
<<<<<<< HEAD
    defusedxml
=======
    cached-property
    defusedxml
    httpx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    isodate
    lxml
    platformdirs
    pytz
    requests
    requests-file
    requests-toolbelt
<<<<<<< HEAD
  ];

  passthru.optional-dependencies = {
    async_require = [
      httpx
    ];
    xmlsec_require = [
      xmlsec
    ];
  };

  pythonImportsCheck = [
    "zeep"
=======
    xmlsec
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    aiohttp
    aioresponses
    freezegun
    mock
    pretend
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    requests-mock
<<<<<<< HEAD
  ]
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/mvantellingen/python-zeep/releases/tag/${version}";
=======
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    # lxml.etree.XMLSyntaxError: Extra content at the end of the document, line 2, column 64
    "test_mime_content_serialize_text_xml"
    # Tests are outdated
    "test_load"
    "test_load_cache"
    "test_post"
  ];

  pythonImportsCheck = [
    "zeep"
  ];

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
