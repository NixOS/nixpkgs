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
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qp0LVcmWf5lZ52h0V58S6FoIM8RLOd6Y3FRb85j7KRg=";
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
