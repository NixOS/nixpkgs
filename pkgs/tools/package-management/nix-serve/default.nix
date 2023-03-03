{ lib
, stdenv
, fetchFromGitHub
, bzip2
, nix
, perl
, makeWrapper
, nixosTests
}:

let
  rev = "7089565e260267c9c234a81292c841958737cef6";
  sha256 = "/nf09eM2vey9GrAXoqagccJrBo/fGyVKP7oNSxPqwdo=";
in

stdenv.mkDerivation {
  pname = "nix-serve";
  version = "0.2-${lib.substring 0 7 rev}";

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
                --prefix PATH : "${lib.makeBinPath [ bzip2 nix ]}" \
                --add-flags $out/libexec/nix-serve/nix-serve.psgi
  '';

  passthru.tests = {
    nix-serve = nixosTests.nix-serve;
    nix-serve-ssh = nixosTests.nix-serve-ssh;
  };

  meta = with lib; {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "A utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    platforms = nix.meta.platforms;
  };
}
