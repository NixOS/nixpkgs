{ stdenv, bash, coreutils, curl, diffutils, gawk, gnugrep, gnused, openssl, makeWrapper, fetchFromGitHub }:
let
  pkgName = "dehydrated";
  version = "0.3.1";
in
stdenv.mkDerivation rec {
  name = pkgName + "-" + version;

  src = fetchFromGitHub {
    owner = "lukas2511";
    repo = "dehydrated";
    rev = "v${version}";
    sha256 = "0prg940ykbsfb4w48bc03j5abycg8v7f9rg9x3kcva37y8ml0jsp";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a dehydrated $out/bin
    wrapProgram "$out/bin/dehydrated" --prefix PATH : "${stdenv.lib.makeBinPath [ openssl coreutils gnused gnugrep diffutils curl gawk ]}"
    '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Letsencrypt/acme client implemented as a shell-script";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.pstn ];
  };
}
