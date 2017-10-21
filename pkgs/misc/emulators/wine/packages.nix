{ system, stdenv, stdenv_32bit, lib, pkgs, pkgsi686Linux, callPackage, callPackage_i686,
  wineRelease ? "stable",
  supportFlags
}:

let src = lib.getAttr wineRelease (callPackage ./sources.nix {});
in with src; {
  wine32 = callPackage_i686 ./base.nix {
    name = "wine-${version}";
    inherit src version supportFlags;
    pkgArches = [ pkgsi686Linux ];
    geckos = [ gecko32 ];
    monos =  [ mono ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
  wine64 = callPackage ./base.nix {
    name = "wine64-${version}";
    inherit src version supportFlags;
    pkgArches = [ pkgs ];
    geckos = [ gecko64 ];
    monos =  [ mono ];
    configureFlags = [ "--enable-win64" ];
    platforms = [ "x86_64-linux" ];
  };
  wineWow = callPackage ./base.nix {
    name = "wine-wow-${version}";
    inherit src version supportFlags;
    stdenv = stdenv_32bit;
    pkgArches = [ pkgs pkgsi686Linux ];
    geckos = [ gecko32 gecko64 ];
    monos =  [ mono ];
    buildScript = ./builder-wow.sh;
    platforms = [ "x86_64-linux" ];
  };
}

