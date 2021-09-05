{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "v${version}";
    sha256 = "sha256-PaLOFZTeX7HxBiOc94x5sHuJYKRF1fR9ShmQN7IPuuo=";
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
