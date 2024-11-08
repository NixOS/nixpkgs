{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "base16-builder";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "base16-builder";
    repo = "base16-builder";
    rev = "refs/tags/${version}";
    hash = "sha256-gmP5jpKrRfY6EO+47PYdIlNSfIlRm9/Vj1q7hyVWmCA=";
  };

  npmDepsHash = "sha256-dGXOhIvJA3xo2FoONQdFth5K3eHXBytWe63gtxjadvA=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  meta = {
    description = "A nimble command-line tool that generates themes for your favourite programs.";
    homepage = "https://github.com/base16-builder/base16-builder#readme";
    license = lib.licenses.mit;
  };
}
