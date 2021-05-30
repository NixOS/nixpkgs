{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "unstable-2021-05-29";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "980755226b0cb46ad9c7f40e0e940f354212a8b7";
    sha256 = "sha256-jO1Dqtv3IbV4FLI3C82pxssgrCf43hAEcPLYszX2GNI=";
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
