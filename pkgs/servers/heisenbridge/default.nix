{ lib, fetchFromGitHub, fetchpatch, python3 }:
python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-sgZql9373xKT7Hi8M5TIZTOkS2AOFoKA1DXYa2f2IkA=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
