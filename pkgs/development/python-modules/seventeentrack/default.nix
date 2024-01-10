{ lib
, aiohttp
, aresponses
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "seventeentrack";
  version = "2022.04.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "McSwindler";
    repo = pname;
    rev = version;
    hash = "sha256-vMdRXcd0es/LjgsVyWItSLFzlSTEa3oaA6lr/NL4i8U=";
  };

  patches = [
    # This patch removes references to setuptools and wheel that are no longer
    # necessary and changes poetry to poetry-core, so that we don't need to add
    # unnecessary nativeBuildInputs.
    #
    #   https://github.com/McSwindler/seventeentrack/pull/4
    #
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/McSwindler/seventeentrack/commit/9a21e22f796a17628a9628f54e19d19d002b4d0a.patch";
      hash = "sha256-UvxUpiSkDbP8Jum5XbrWHBnH1HLBYEKUKw6GTV+Kvys=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    attrs
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_
    "examples/"
  ];

  pythonImportsCheck = [
    "seventeentrack"
  ];

  meta = with lib; {
    description = "Python library to track package info from 17track.com";
    homepage = "https://github.com/McSwindler/seventeentrack";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
