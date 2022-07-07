{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, jq, findutils, nix  }:

stdenv.mkDerivation rec {
  pname = "nixos-generators";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-generators";
    rev = version;
    sha256 = "sha256-dpim9Mtd57Yj6qt7p7UKwjWm6NnOU3S7jaEyEscSyPE=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installFlags = [ "PREFIX=$(out)" ];
  postFixup = ''
    wrapProgram $out/bin/nixos-generate \
      --prefix PATH : ${lib.makeBinPath [ jq coreutils findutils nix ] }
  '';

  meta = with lib; {
    description = "Collection of image builders";
    homepage    = "https://github.com/nix-community/nixos-generators";
    license     = licenses.mit;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "nixos-generate";
    platforms   = platforms.unix;
  };
}
