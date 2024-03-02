{ stdenv, lib, fetchsvn
, cmake, pkg-config, perl, vala
, gtk2, pcre, zlib, libpng, fribidi, harfbuzzFull, xorg, util-linux, curl
, SDL, SDL_image, SDL_mixer, libselinux, libsepol
, version, rev, sha256
}:

stdenv.mkDerivation rec {
  pname = "crossfire-client";
  version = rev;

  src = fetchsvn {
    url = "http://svn.code.sf.net/p/crossfire/code/client/trunk/";
    inherit sha256;
    rev = "r${rev}";
  };

  nativeBuildInputs = [ cmake pkg-config perl vala ];
  buildInputs = [
    gtk2 pcre zlib libpng fribidi harfbuzzFull xorg.libpthreadstubs
    xorg.libXdmcp curl SDL SDL_image SDL_mixer util-linux libselinux libsepol
  ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GTKv2 client for the Crossfire free MMORPG";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
