{ lib, stdenv, coreutils, curl, diffutils, gawk, gnugrep, gnused, openssl, makeWrapper, fetchFromGitHub, installShellFiles }:
stdenv.mkDerivation rec {
  pname = "dehydrated";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lukas2511";
    repo = "dehydrated";
    rev = "v${version}";
    sha256 = "09jhmkjvnj98zbf92qwdr5rr7pc6v63xzyk2fbi177r7szb2yg09";
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
    wrapProgram "$out/bin/dehydrated" --prefix PATH : "${lib.makeBinPath [ openssl coreutils gnused gnugrep diffutils curl gawk ]}"
    '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Letsencrypt/acme client implemented as a shell-script";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.pstn ];
  };
}
