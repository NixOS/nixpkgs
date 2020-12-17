{ stdenv_32bit, lib, pkgs, pkgsi686Linux, pkgsCross, callPackage,
  wineRelease ? "stable",
  supportFlags
}:

let src = lib.getAttr wineRelease (callPackage ./sources.nix {});
in with src; {
  wine32 = pkgsi686Linux.callPackage ./base.nix {
    name = "wine-${version}";
    inherit src version supportFlags patches;
    pkgArches = [ pkgsi686Linux ];
    geckos = [ gecko32 ];
    mingwGccs = with pkgsCross; [ mingw32.buildPackages.gcc ];
    monos =  [ mono ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
  wine64 = callPackage ./base.nix {
    name = "wine64-${version}";
    inherit src version supportFlags patches;
    pkgArches = [ pkgs ];
    mingwGccs = with pkgsCross; [ mingwW64.buildPackages.gcc ];
    geckos = [ gecko64 ];
    monos =  [ mono ];
    configureFlags = [ "--enable-win64" ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
  wineWow = callPackage ./base.nix {
    name = "wine-wow-${version}";
    inherit src version supportFlags patches;
    stdenv = stdenv_32bit;
    pkgArches = [ pkgs pkgsi686Linux ];
    geckos = [ gecko32 gecko64 ];
    mingwGccs = with pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
    monos =  [ mono ];
    buildScript = ./builder-wow.sh;
    platforms = [ "x86_64-linux" ];
  };
}
