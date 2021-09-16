{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "v${version}";
    sha256 = "sha256-7B4orrANb4hTXJ4cFYxhmrOgEIoU3TPmsR239JhIrTw=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    pyyaml
  ];

  checkInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
