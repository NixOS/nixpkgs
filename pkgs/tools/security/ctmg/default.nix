{ stdenv, fetchurl, ...  }:

stdenv.mkDerivation rec {
  name    = "ctmg-${version}";
  version = "1.2";

  src = fetchurl {
    url    = "https://git.zx2c4.com/ctmg/snapshot/ctmg-${version}.tar.xz";
    sha256 = "1djxrf66abl63cybxfgjshr8avbp6nq158d0jx4mlfa3pdj32kv9";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ctmg.sh $out/bin/ctmg
  '';

  meta = with stdenv.lib; {
    description = "An encrypted container manager for Linux using cryptsetup";
    homepage    = https://git.zx2c4.com/ctmg/about/;
    license     = licenses.free;
    maintainers = with maintainers; [ mrVanDalo ];
    platforms   = platforms.linux;
  };
}

