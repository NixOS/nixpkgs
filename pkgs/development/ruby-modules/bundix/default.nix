{ lib, stdenv, fetchFromGitHub, nix, nix-prefetch-git, bundler, makeWrapper }:
stdenv.mkDerivation rec {
  version = "2.2.0";
  name = "bundix-${version}";

  src = fetchFromGitHub {
    owner = "manveru";
    repo = "bundix";
    rev = version;
    sha256 = "0lnzkwxprdz73axk54y5p5xkw56n3lra9v2dsvqjfw0ab66ld0iy";
  };
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out
    makeWrapper $src/bin/bundix $out/bin/bundix \
      --prefix PATH : "${nix.out}/bin" \
      --prefix PATH : "${nix-prefetch-git.out}/bin" \
      --set GEM_PATH "${bundler}/${bundler.ruby.gemPath}"
  '';

  nativeBuildInputs = [makeWrapper];

  meta = {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru zimbatm ];
    platforms = lib.platforms.all;
  };
}
