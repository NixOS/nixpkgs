{ stdenv, fetchFromGitHub, zlib, bzip2 }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "undmg-${version}";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "refs/tags/v${version}";
    sha256 = "0w9vwvj9zbpsjkg251bwv9y10wjyjmh54q2piklz74w64rlbqblr";
    name = "undmg-${version}";
  };

  buildInputs = [ zlib bzip2 ];

  setupHook = ./setup-hook.sh;

  installFlags = "PREFIX=\${out}";

  meta = {
    homepage = https://github.com/matthewbauer/undmg;
    description = "Extract a DMG file";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.all;
  };
}
