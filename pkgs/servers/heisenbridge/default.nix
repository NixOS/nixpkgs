{ lib, fetchFromGitHub, fetchpatch, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {
      mautrix = super.mautrix.overridePythonAttrs (oldAttrs: rec {
        version = "0.16.10";
        src = fetchFromGitHub {
          owner = "mautrix";
          repo = "python";
          rev = "v${version}";
          hash = "sha256-YQsQ7M+mHcRdGUZp+mo46AlBmKSdmlgRdGieEG0Hu9k=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
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
    irc
    ruamel-yaml
    mautrix
    python-socks
  ];

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
