{ lib, buildGoModule, fetchFromGitHub }:

let
  srcInfo = lib.importJSON ./src.json;
in

buildGoModule rec {
  pname = "chroma";
<<<<<<< HEAD
  version = "2.8.0";
=======
  version = "2.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # To update:
  # nix-prefetch-git --rev v${version} https://github.com/alecthomas/chroma.git > src.json
  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    inherit (srcInfo) sha256;
  };

<<<<<<< HEAD
  vendorSha256 = "1qawayihklidfzln3jr899wh4zp9w7yq3i18klaylqndrg47k286";
=======
  vendorSha256 = "0kw53983bjrmh9nk2xcv4d9104krxnc1jh1g44xjmaq8i6f3q0k1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  modRoot = "./cmd/chroma";

  # substitute version info as done in goreleaser builds
  ldflags = [
    "-X" "main.version=${version}"
    "-X" "main.commit=${srcInfo.rev}"
    "-X" "main.date=${srcInfo.date}"
  ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
