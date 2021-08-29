{ lib, stdenv, fetchFromGitHub,
  bzip2, nix, perl, makeWrapper,
}:

with lib;

let
  rev = "e4675e38ab54942e351c7686e40fabec822120b9";
  sha256 = "1wm24p6pkxl1d7hrvf4ph6mwzawvqi22c60z9xzndn5xfyr4v0yr";
in

stdenv.mkDerivation {
  name = "nix-serve-0.2-${substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    makeWrapper ${perl.withPackages(p: [ p.DBDSQLite p.Plack p.Starman nix.perl-bindings ])}/bin/starman $out/bin/nix-serve \
                --prefix PATH : "${makeBinPath [ bzip2 nix ]}" \
                --add-flags $out/libexec/nix-serve/nix-serve.psgi
  '';

  meta = {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "A utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    platforms = nix.meta.platforms;
  };
}
