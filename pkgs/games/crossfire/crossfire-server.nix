<<<<<<< HEAD
{ stdenv
, lib
, fetchsvn
, autoreconfHook
, autoconf
, automake
, libtool
, flex
, perl
, check
, pkg-config
, python39 # crossfire-server relies on a parser wich was removed in python >3.9
, version
, rev
, sha256
, maps
, arch
}:
=======
{ stdenv, lib, fetchsvn, autoreconfHook,
  autoconf, automake, libtool, flex, perl, check, pkg-config, python3,
  version, rev, sha256, maps, arch }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "crossfire-server";
  version = rev;

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/server/trunk/";
    inherit sha256;
    rev = "r${rev}";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ autoconf automake libtool flex perl check pkg-config python39 ];
=======
  nativeBuildInputs = [ autoconf automake libtool flex perl check pkg-config python3 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  hardeningDisable = [ "format" ];

  preConfigure = ''
    ln -s ${arch} lib/arch
    ln -s ${maps} lib/maps
    sh autogen.sh
  '';

<<<<<<< HEAD
  configureFlags = [ "--with-python=${python39}" ];
=======
  configureFlags = [ "--with-python=${python3}" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    ln -s ${maps} "$out/share/crossfire/maps"
  '';

  meta = with lib; {
    description = "Server for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
