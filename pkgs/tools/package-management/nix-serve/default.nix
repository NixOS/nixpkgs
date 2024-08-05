{ lib
, stdenv
, fetchFromGitHub
, bzip2
, nix
, nixVersions
, perl
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation {
  pname = "nix-serve";
  version = "0.2.0-unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    rev = "4a12660e6fa8fce662c0a652280a3309fa822465";
    hash = "sha256-N7MK+m7hP34ALPy2tKgfPmz+uj/pkbh1Wq771BMHAfI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    makeWrapper ${perl.withPackages(p: [ p.DBDSQLite p.Plack p.Starman nix.perl-bindings ])}/bin/starman $out/bin/nix-serve \
      --prefix PATH : "${lib.makeBinPath [ bzip2 nixVersions.nix_2_3 ]}" \
      --add-flags $out/libexec/nix-serve/nix-serve.psgi
  '';

  passthru.tests = {
    nix-serve = nixosTests.nix-serve;
    nix-serve-ssh = nixosTests.nix-serve-ssh;
  };

  meta = with lib; {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "Utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    platforms = nix.meta.platforms;
    mainProgram = "nix-serve";
  };
}
