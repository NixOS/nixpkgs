{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, jq, findutils, nix  }:

stdenv.mkDerivation rec {
  pname = "nixos-generators";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-generators";
    rev = version;
    sha256 = "1iwc39hzvzzyndxwbnl3fck7phxnjpnhy8zn4nyp8is1fiw0648v";
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
    platforms   = platforms.unix;
  };
}
