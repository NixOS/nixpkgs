{ lib
, buildPythonPackage
, fetchPypi
, trio
, outcome
, sniffio
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.12.0";

  src = fetchPypi {
    pname = "trio_asyncio";
    inherit version;
    sha256 = "824be23b0c678c0df942816cdb57b92a8b94f264fffa89f04626b0ba2d009768";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  propagatedBuildInputs = [
    trio
    outcome
    sniffio
  ];

  checkInputs = [
    pytest-trio
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/python" # tries to import internal API test.test_asyncio
  ];

  meta = with lib; {
    description = "Re-implementation of the asyncio mainloop on top of Trio";
    homepage = "https://github.com/python-trio/trio-asyncio";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
