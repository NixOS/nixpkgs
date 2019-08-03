{ stdenv, lib, callPackage }:
let src = (callPackage ./sources.nix {}).stable;
in
stdenv.mkDerivation {
  pname = "wine-fonts";
  inherit (src) version;

  sourceRoot = "wine-${src.version}/fonts";
  inherit src;

  installPhase = ''
    install *.ttf -Dt $out/share/fonts/wine
  '';

  meta = {
    description = "Microsoft replacement fonts by the Wine project";
    homepage = "https://wiki.winehq.org/Create_Fonts";
    license = with lib.licenses; [ lgpl21Plus ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ avnik raskin bendlas johnazoidberg ];
  };
}
