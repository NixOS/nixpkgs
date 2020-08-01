{ stdenv, fetchFromGitHub, zlib, bzip2 }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  pname = "undmg";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "v${version}";
    sha256 = "0yz5fniaa5z33d8bdzgr263957r1c9l99237y2p8k0hdid207la1";
  };

  buildInputs = [ zlib bzip2 ];

  setupHook = ./setup-hook.sh;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/matthewbauer/undmg";
    description = "Extract a DMG file";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ matthewbauer lnl7 ];
  };
}
