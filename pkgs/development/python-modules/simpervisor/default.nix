{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytest-asyncio
, aiohttp
}:

buildPythonPackage rec {
  pname = "simpervisor";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "yuvipanda";
    repo = "simpervisor";
    rev = "v${version}";
    sha256 = "1brsisx7saf4ic0dih1n5y7rbdbwn1ywv9pl32bch3061r46prvv";
  };

  checkInputs = [
    pytest
    pytest-asyncio
    aiohttp
  ];

  checkPhase = ''
    pytest --ignore tests/test_ready.py
  '';

  meta = with lib; {
    description = "Simple async process supervisor";
    homepage = https://github.com/yuvipanda/simpervisor;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
