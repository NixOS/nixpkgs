{ stdenv, lib, fetchgit, autoreconfHook
, autoconf
, automake
, libtool
, flex
, perl
, check
, pkg-config
, python39 # crossfire-server relies on a parser wich was removed in python >3.9
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
, maps, arch
}:

stdenv.mkDerivation rec {
  pname = "crossfire-server";
  inherit version;

  src = fetchgit {
    url = "http://git.code.sf.net/p/crossfire/crossfire-server";
    inherit rev hash;
  };

  patches = [
    ./add-cstdint-include-to-crossfire-server.patch
  ];

  nativeBuildInputs = [ autoconf automake libtool flex perl check pkg-config python39 ];
  hardeningDisable = [ "format" ];

  preConfigure = ''
    ln -s ${arch} lib/arch
    ln -s ${maps} lib/maps
    sh autogen.sh
  '';

  configureFlags = [ "--with-python=${python39}" ];

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
