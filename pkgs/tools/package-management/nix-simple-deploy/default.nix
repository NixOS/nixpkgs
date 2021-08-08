{ lib, fetchFromGitHub, rustPlatform, makeWrapper, openssh, nix-serve }:

rustPlatform.buildRustPackage rec {
  pname = "nix-simple-deploy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "misuzu";
    repo = pname;
    rev = version;
    sha256 = "0vkgs3ffb5vdzhrqdnd54vbi36vrgd3408zvjn0rmqlnwi3wwhnk";
  };

  cargoSha256 = "0z4d4cazl6qvigyqzdayxqfjc1ki1rhrpm76agc8lkrxrvhyay2h";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/nix-simple-deploy" \
      --prefix PATH : "${lib.makeBinPath [ openssh nix-serve ]}"
  '';

  meta = with lib; {
    description = "Deploy software or an entire NixOS system configuration to another NixOS system";
    homepage = "https://github.com/misuzu/nix-simple-deploy";
    platforms = lib.platforms.unix;
    license = with licenses; [ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ misuzu ];
  };
}
