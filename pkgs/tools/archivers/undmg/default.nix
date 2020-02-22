{ stdenv, fetchFromGitHub, zlib, bzip2 }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  pname = "undmg";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "v${version}";
    sha256 = "1pxqw92h2w75d4jwiihwnkhnsfk09cddh3flgrqwh9r3ry14fgbb";
    
  };

  buildInputs = [ zlib bzip2 ];

  setupHook = ./setup-hook.sh;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matthewbauer/undmg;
    description = "Extract a DMG file";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ matthewbauer lnl7 ];
  };
}
