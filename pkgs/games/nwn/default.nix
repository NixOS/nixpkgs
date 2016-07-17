{ stdenv, fetchurl, fetchgit, requireFile
, perl, innoextract, unzip, p7zip, icoutils
, libX11, libXcursor, libelf, SDL, SDL_gfx, mesa_glu
, binkplayer
}:

stdenv.mkDerivation rec {
  name = "nwn-gog-${version}";
  version = "2.0.0.15";

  inherit binkplayer;

  gogSetup = requireFile {
    name = "setup_nwn_diamond_${version}.exe";
    url = "http://www.gog.com/game/neverwinter_nights_diamond_edition";
    sha256 = "45852cf42a5df5cd214e77519b55bc45e49add9b029fefc58f3f4efc6ae772c1";
  };

  gogData1 = requireFile {
    name = "setup_nwn_diamond_${version}-1.bin";
    url = "http://www.gog.com/game/neverwinter_nights_diamond_edition";
    sha256 = "4b535281a74fbb26f1f5752527906def370d1cc28ffde396b672fd74259f1c56";
  };

  gogData2 = requireFile {
    name = "setup_nwn_diamond_${version}-2.bin";
    url = "http://www.gog.com/game/neverwinter_nights_diamond_edition";
    sha256 = "9b9d5ae7af6000ed4e3a6c13b36c6b16096814044dc50845094386a028cb8336";
  };

  gogmods = requireFile {
    name = "nvn_KingmakerSetup.zip";
    url = "http://www.gog.com/game/neverwinter_nights_diamond_edition";
    sha256 = "a3fe832f4673a298fc29ffdc8957f9122a185321804170370a0d8f6c6a07f1aa";
  };

  clientgold = fetchurl {
    url = "http://nwdownloads.bioware.com/neverwinternights/linux/gold/nwclientgold.tar.gz";
    sha256 = "1wwm6gsjs94pr0g2x838p4qql7a5nf68h8d1yhz77jgnwb777ska";
  };

  clienthotu = fetchurl {
    url = "http://nwdownloads.bioware.com/neverwinternights/linux/161/nwclienthotu.tar.gz";
    sha256 = "1mygvzvqbfs704pgar87b27x53g9bb74kllvs1kb37ynmhdcwjha";
  };

  clientpatch = fetchurl {
    url = "http://files.bioware.com/neverwinternights/updates/linux/169/English_linuxclient169_xp2.tar.gz";
    sha256 = "0gvnk6bcd5qhsr8vm30dac0ybp0y3gndw66j01zyy9f0jlmmww89";
  };

  nwmouse = fetchgit {
    url = "https://github.com/nwnlinux/nwmouse";
    rev = "6df8b96f0dbf34d0c42511c3f0cdc11b71573aa0";
    sha256 = "30f47cdae98a30260472c56c845d850b59fb608882f3444e3eeaaac2548a4729";
  };

  nwuser = fetchgit {
    url = "https://github.com/nwnlinux/nwuser";
    rev = "3fbbf546a8ba9cc1e35ba5a718018402baaa658d";
    sha256 = "d1fb4b922d84e14587a80e594797039b3198186899d8a06627726a51d11dc7c2";
  };

  nwlogger = fetchgit {
    url = "https://github.com/nwnlinux/nwlogger";
    rev = "3bfa7aa58621584dc734cf2f856d49c76840dc14";
    sha256 = "9506a986548e819154bfcd39e7e8aab907000ace2dd10d93c59e3eff8b362668";
  };

  nwmovies = fetchgit {
    url = "https://github.com/nwnlinux/nwmovies";
    rev = "61fb36453b4d99e710d1bd17b3fd68f529596617";
    sha256 = "d2b892bf09eedaf8a145053d864c7ccf6ccfc1ca5e44a758c0ce1ac6ecaf8aea";
  };

  nativeBuildInputs = [ perl innoextract icoutils unzip p7zip ];

  buildInputs = [ libX11 libXcursor libelf SDL ];

  deps = stdenv.lib.makeLibraryPath (buildInputs ++ [ mesa_glu SDL_gfx ]);

  launcher = ./launcher.sh;

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "Neverwinter Nights, RPG from Bioware. GOG version";
    homepage = "http://www.gog.com/game/neverwinter_nights_diamond_edition";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
