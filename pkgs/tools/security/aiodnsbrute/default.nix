{ lib
, buildPythonApplication
, fetchFromGitHub
, aiodns
, click
, tqdm
, uvloop
}:

buildPythonApplication rec {
  pname = "aiodnsbrute";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "blark";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fs8544kx7vwvc97zpg4rs3lmvnb4vwika5g952rv3bfx4rv3bpg";
  };

  # https://github.com/blark/aiodnsbrute/pull/8
  prePatch = ''
    substituteInPlace setup.py --replace " 'asyncio', " ""
  '';

  propagatedBuildInputs = [
     aiodns
     click
     tqdm
     uvloop
  ];

  # no tests present
  doCheck = false;

  pythonImportsCheck = [ "aiodnsbrute.cli" ];

  meta = with lib; {
    description = "DNS brute force utility";
    homepage = "https://github.com/blark/aiodnsbrute";
    # https://github.com/blark/aiodnsbrute/issues/5
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
