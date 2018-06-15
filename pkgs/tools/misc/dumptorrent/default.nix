{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
    name = "dumptorrent-${version}";
    version = "1.2";
    
    src = fetchurl {
      url = "mirror://sourceforge/dumptorrent/dumptorrent-${version}.tar.gz";
      sha256 = "073h03bmpfdy15qh37lvppayld2747i4acpyk0pm5nf2raiak0zm";
    };

    patchPhase = ''
      substituteInPlace Makefile \
        --replace "gcc" "cc"
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ./dumptorrent $out/bin
    '';

    meta = with stdenv.lib; {
      description = "Dump .torrent file information";
      homepage = https://sourceforge.net/projects/dumptorrent/;
      license = licenses.gpl2;
      maintainers = [ maintainers.zohl ];
      platforms = platforms.all;
    };
}
