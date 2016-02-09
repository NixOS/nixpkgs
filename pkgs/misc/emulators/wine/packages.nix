{ system, stdenv, stdenv_32bit, lib, pkgs, pkgsi686Linux, callPackage,
  pulseaudioSupport,
  wineRelease ? "stable"
}:

let src = lib.getAttr wineRelease (callPackage ./sources.nix {});
in with src; {
  wine32 = import ./base.nix {
    name = "wine-${version}";
    inherit src version pulseaudioSupport;
    inherit (pkgsi686Linux) lib stdenv;
    pkgArches = [ pkgsi686Linux ];
    geckos = [ gecko32 ];
    monos =  [ mono ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
  wine64 = import ./base.nix {
    name = "wine64-${version}";
    inherit src version pulseaudioSupport lib stdenv;
    pkgArches = [ pkgs ];
    geckos = [ gecko64 ];
    monos =  [ mono ];
    configureFlags = "--enable-win64";
    platforms = [ "x86_64-linux" ];
  };
  wineWow = import ./base.nix {
    name = "wine-wow-${version}";
    inherit src version pulseaudioSupport lib;
    stdenv = stdenv_32bit;
    pkgArches = [ pkgs pkgsi686Linux ];
    geckos = [ gecko32 gecko64 ];
    monos =  [ mono ];
    buildScript = ./builder-wow.sh;
    platforms = [ "x86_64-linux" ];
  };
}

