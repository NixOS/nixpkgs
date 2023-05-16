{ buildGoModule, fetchFromGitHub, lib, symlinkJoin }:
let
<<<<<<< HEAD
  generic = { modRoot, vendorHash }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.3.1";
=======
  generic = { modRoot, vendorSha256 }:
    buildGoModule rec {
      pname = "bird-lg-${modRoot}";
      version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchFromGitHub {
        owner = "xddxdd";
        repo = "bird-lg-go";
        rev = "v${version}";
<<<<<<< HEAD
        hash = "sha256-ROMwgsKroxd9qkKX8ZoOuazBrnZytcTAPT9hR/v6a04=";
=======
        sha256 = "sha256-Ldp/c1UU5EFnKjlUqQ+Hh6rVEOYEX7kaDL36edr9pNA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      doDist = false;

      ldflags = [
        "-s"
        "-w"
      ];

<<<<<<< HEAD
      inherit modRoot vendorHash;
=======
      inherit modRoot vendorSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      meta = with lib; {
        description = "Bird Looking Glass";
        homepage = "https://github.com/xddxdd/bird-lg-go";
        changelog = "https://github.com/xddxdd/bird-lg-go/releases/tag/v${version}";
        license = licenses.gpl3Plus;
<<<<<<< HEAD
        maintainers = with maintainers; [
          tchekda
          e1mo
        ];
=======
        maintainers = with maintainers; [ tchekda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };

  bird-lg-frontend = generic {
    modRoot = "frontend";
<<<<<<< HEAD
    vendorHash = "sha256-yyH6McVzU0Qiod3yP5pGlF36fJQlf4g52wfDAem6KWs=";
=======
    vendorSha256 = "sha256-lYOi3tfXYhsFaWgikDUoJYRm8sxFNFKiFQMlVx/8AkA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  bird-lg-proxy = generic {
    modRoot = "proxy";
<<<<<<< HEAD
    vendorHash = "sha256-JfHvDIVKQ7jdPocuh6AOwSQmP+a0/hXYrt5Ap/pEjug=";
=======
    vendorSha256 = "sha256-QHLq4RuQaCMjefs7Vl7zSVgjLMDXvIZcM8d6/B5ECZc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
symlinkJoin {
  name = "bird-lg-${bird-lg-frontend.version}";
  paths = [ bird-lg-frontend bird-lg-proxy ];
} // {
  inherit (bird-lg-frontend) version meta;
}
