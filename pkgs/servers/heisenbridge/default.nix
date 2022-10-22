{ lib, fetchFromGitHub, fetchpatch, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.16.3";
        src = oldAttrs.src.override {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-OpHLh5pCzGooQ5yxAa0+85m/szAafV+l+OfipQcfLtU=";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
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

  propagatedBuildInputs = with python.pkgs; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
