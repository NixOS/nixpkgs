{ stdenv, fetchurl, x11, SDL, mesa, openal }:

stdenv.mkDerivation {
  name = "ioquake3-1.36";
  
  src = fetchurl {
    url = http://ioquake3.org/files/1.36/ioquake3-1.36.tar.bz2; # calls itself "1.34-rc3"
    sha256 = "008vah60z0n9h1qp373xbqvhwfbyywbbhd1np0h0yw66g0qzchzv";
  };

  patchFlags = "-p0";
  
  patches = [
    # Fix for compiling on gcc 4.2.
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/games-fps/quake3/files/quake3-1.34_rc3-gcc42.patch?rev=1.1";
      sha256 = "06c9lxfczcby5q29pim231mr2wdkvbv36xp9zbxp9vk0dfs8rv9x";
    })

    # Do an exit() instead of _exit().  This is nice for gcov.
    # Upstream also seems to do this.
    ./exit.patch    
  ];
  
  buildInputs = [x11 SDL mesa openal];

  # Fix building on GCC 4.6.
  NIX_CFLAGS_COMPILE = "-Wno-error";

  preInstall = ''
    mkdir -p $out/baseq3
    installTargets=copyfiles
    installFlags="COPYDIR=$out"
  '';
  
}
