{ system, stdenv, stdenv_32bit, lib, pkgs, pkgsi686Linux, fetchurl,
  wineRelease ? "stable"
}:

let sources = with lib.getAttr wineRelease (import ./versions.nix); {
      version = wineVersion;
      src = fetchurl {
        url = "mirror://sourceforge/wine/wine-${wineVersion}.tar.bz2";
        sha256 = wineSha256;
      };

      wineGecko32 = fetchurl {
        url = "mirror://sourceforge/wine/wine_gecko-${geckoVersion}-x86.msi";
        sha256 = geckoSha256;
      };

      wineGecko64 = fetchurl {
        url = "mirror://sourceforge/wine/wine_gecko-${gecko64Version}-x86_64.msi";
        sha256 = gecko64Sha256;
      };

      wineMono = fetchurl {
        url = "mirror://sourceforge/wine/wine-mono-${monoVersion}.msi";
        sha256 = monoSha256;
      };
    };
    inherit (sources) version;
in {
  wine32 = import ./base.nix {
    name = "wine-${version}";
    inherit (sources) version src;
    inherit (pkgsi686Linux) lib stdenv;
    pkgArches = [ pkgsi686Linux ];
    geckos = with sources; [ wineGecko32 ];
    monos = with sources; [ wineMono ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
  wine64 = import ./base.nix {
    name = "wine64-${version}";
    inherit (sources) version src;
    inherit lib stdenv;
    pkgArches = [ pkgs ];
    geckos = with sources; [ wineGecko64 ];
    monos = with sources; [ wineMono ];
    configureFlags = "--enable-win64";
    platforms = [ "x86_64-linux" ];
  };
  wineWow = import ./base.nix {
    name = "wine-wow-${version}";
    inherit (sources) version src;
    inherit lib;
    stdenv = stdenv_32bit;
    pkgArches = [ pkgs pkgsi686Linux ];
    geckos = with sources; [ wineGecko32 wineGecko64 ];
    monos = with sources; [ wineMono ];
    buildScript = ./builder-wow.sh;
    platforms = [ "x86_64-linux" ];
  };
}

