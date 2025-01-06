{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  tiktoken,
}:

buildPythonPackage rec {
  pname = "tokentrim";
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KillianLucas";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zr2SLT3MBuMD98g9fdS0mLuijcssRQ/S3+tCq2Cw1/4=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ tiktoken ];

  pythonImportsCheck = [ "tokentrim" ];

  # tests connect to openai
  doCheck = false;

  meta = with lib; {
    description = "Easily trim 'messages' arrays for use with GPTs";
    homepage = "https://github.com/KillianLucas/tokentrim";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
