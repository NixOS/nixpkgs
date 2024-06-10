{ lib, stdenv, coreutils, curl, diffutils, gawk, gnugrep, gnused, hexdump, openssl, makeWrapper, fetchFromGitHub, installShellFiles }:
stdenv.mkDerivation rec {
  pname = "dehydrated";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lukas2511";
    repo = "dehydrated";
    rev = "v${version}";
    sha256 = "sha256-K08eeruyT5vKzK3PzfCkubZiHbf9Yq7wzD1z69MeDtY=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    installManPage docs/man/dehydrated.1

    mkdir -p "$out/share/docs/dehydrated"
    cp docs/*.md "$out/share/docs/dehydrated"
    cp -r docs/examples "$out/share/docs/dehydrated"
    cp {CHANGELOG,LICENSE,README.md} "$out/share/docs/dehydrated"

    mkdir -p $out/bin
    cp -a dehydrated $out/bin
    wrapProgram "$out/bin/dehydrated" --prefix PATH : "${lib.makeBinPath [ openssl coreutils gnused gnugrep diffutils curl gawk hexdump ]}"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Letsencrypt/acme client implemented as a shell-script";
    mainProgram = "dehydrated";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.pstn ];
  };
}
