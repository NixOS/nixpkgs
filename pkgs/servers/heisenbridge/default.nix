{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q1Rj8BehvYnV/Kah5YKAxBUz4j9WziSqn1fVeaKpy7g=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
