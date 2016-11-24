{ stdenv, fetchFromGitHub, zlib, bzip2 }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  name = "undmg-${version}";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "v${version}";
    sha256 = "1pxqw92h2w75d4jwiihwnkhnsfk09cddh3flgrqwh9r3ry14fgbb";
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
