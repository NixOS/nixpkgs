{ stdenv, lib, fetchgit
, cmake, pkg-config, perl, vala
, gtk2, pcre, pcre2, zlib, libpng, libthai, fribidi, harfbuzzFull, xorg
, util-linux, curl, SDL, SDL_image, SDL_mixer, libselinux, libsepol, libdatrie
, rev, hash, version ? "git+${builtins.substring 0 7 rev}"
}:

stdenv.mkDerivation rec {
  pname = "crossfire-client";
  inherit version;

  src = fetchgit {
    url = "http://git.code.sf.net/p/crossfire/crossfire-client";
    inherit rev hash;
  };

  nativeBuildInputs = [ cmake pkg-config perl vala ];
  buildInputs = [
    gtk2 pcre pcre2 zlib libpng libthai fribidi harfbuzzFull xorg.libpthreadstubs
    xorg.libXdmcp curl SDL SDL_image SDL_mixer util-linux libselinux libsepol
    libdatrie
  ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GTKv2 client for the Crossfire free MMORPG";
    mainProgram = "crossfire-client-gtk2";
    homepage = "http://crossfire.real-time.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
