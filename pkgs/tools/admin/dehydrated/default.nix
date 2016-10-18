{ stdenv, bash, curl, openssl, makeWrapper, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "dehydrated-0.3.1";

  src = fetchFromGitHub {
    owner = "lukas2511";
    repo = "dehydrated";
    rev = "ec49a4433b48a7bc8f178d06dad3f55cff24bdf3";
    sha256 = "0prg940ykbsfb4w48bc03j5abycg8v7f9rg9x3kcva37y8ml0jsp";
  };

  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp -a dehydrated $out/bin
    cp -a docs $out/
    cp -a CHANGELOG $out/
    wrapProgram "$out/bin/dehydrated" --prefix PATH : "${stdenv.lib.makeBinPath [ curl openssl ]}"
    '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "This is a client for signing certificates with an ACME-server (currently only provided by letsencrypt) implemented as a relatively simple bash-script.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
