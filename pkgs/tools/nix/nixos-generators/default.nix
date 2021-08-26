{ stdenv, lib, fetchFromGitHub, makeWrapper, coreutils, jq, findutils, nix  }:

stdenv.mkDerivation rec {
  pname = "nixos-generators";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-generators";
    rev = version;
    sha256 = "1kn2anp8abpi0n3p7j0yczbpy7mdhk8rv84ywyghqdvf2wjmnlnp";
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
