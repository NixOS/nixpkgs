{ lib, fetchFromGitHub, fetchpatch, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      mautrix_0_13 = self.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.13.3";
        src = oldAttrs.src.override {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1e4a292469f3e200c182aaa5bf693a5c3834b2a0cfb3d29e4c9a1559db7740e3";
        };
      });
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "v${version}";
    sha256 = "173prcd56rwlxjxlw67arnm12k1l317xi5s6m7jhmp8zbbrj5vwr";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

  propagatedBuildInputs = with python.pkgs; [
    aiohttp
    irc
    mautrix_0_13
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
