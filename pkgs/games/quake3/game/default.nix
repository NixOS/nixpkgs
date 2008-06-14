{stdenv, fetchurl, x11, SDL, mesa, openal}:

stdenv.mkDerivation {
  name = "ioquake3-1.34-pre-rc3";
  
  src = fetchurl {
    url = http://ioquake3.org/files/ioquake3_1.34-rc3.tar.bz2;
    sha256 = "008vah60z0n9h1qp373xbqvhwfbyywbbhd1np0h0yw66g0qzchzv";
  };

  patchFlags = "-p0";
  
  patches = [
    # Fix for compiling on gcc 4.2.
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/games-fps/quake3/files/quake3-1.34_rc3-gcc42.patch?rev=1.1";
      sha256 = "06c9lxfczcby5q29pim231mr2wdkvbv36xp9zbxp9vk0dfs8rv9x";
    })
  ];
  
  buildInputs = [x11 SDL mesa openal];

  preInstall = ''
    ensureDir $out/baseq3
    installTargets=copyfiles
    installFlags="COPYDIR=$out"
  '';
  
}
