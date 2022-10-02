{ stdenv, lib, fetchsvn, autoreconfHook,
  autoconf, automake, libtool, flex, perl, check, pkg-config, python3,
  version, rev, sha256, maps, arch }:

stdenv.mkDerivation rec {
  pname = "crossfire-server";
  version = rev;

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/server/trunk/";
    inherit sha256;
    rev = "r${rev}";
  };

  nativeBuildInputs = [ autoconf automake libtool flex perl check pkg-config python3 ];
  hardeningDisable = [ "format" ];

  preConfigure = ''
    ln -s ${arch} lib/arch
    ln -s ${maps} lib/maps
    sh autogen.sh
  '';

  configureFlags = [ "--with-python=${python3}" ];

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
