{ lib
, stdenv
, fetchFromGitHub
, bzip2
, nix
, perl
, makeWrapper
, nixosTests
}:

stdenv.mkDerivation {
  pname = "nix-serve";
  version = "0-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-serve";
    rev = "f2529a143bc6a41471e0374a983211552223aba8";
    sha256 = "sha256-5fxrCEjx2ej0uvqDSFdQPD1LIpJ6jmbenjsX5SFiuuQ=";
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
    homepage = "https://github.com/nix-community/nix-serve";
    description = "Utility for sharing a Nix store as a binary cache";
    maintainers = [
      maintainers.eelco
      maintainers.mic92
    ];
    license = licenses.lgpl21;
    platforms = nix.meta.platforms;
    mainProgram = "nix-serve";
  };
}
