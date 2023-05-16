<<<<<<< HEAD
{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.14.5";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-OmAmgHM+EmJ3mUY4lPBxIv2rAq8j2QEeTUMux7ZBfRE=";
=======
    sha256 = "sha256-qp0LVcmWf5lZ52h0V58S6FoIM8RLOd6Y3FRb85j7KRg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

<<<<<<< HEAD
  propagatedBuildInputs = with python3.pkgs; [
=======
  propagatedBuildInputs = with python.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    irc
    ruamel-yaml
    mautrix
    python-socks
  ];

<<<<<<< HEAD
  nativeCheckInputs = with python3.pkgs; [
=======
  nativeCheckInputs = with python.pkgs; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
