{ lib }:

oldTlcontrib:

let
  # pdftex-dev was last updated in November 2021 and it has no build
  # instructions, we can safely drop it
  orig = removeAttrs oldTlcontrib [ "00texlive.config" "pdftex-dev" ];

in lib.recursiveUpdate orig rec {
  #### overrides of tlcontrib/tlpkg/texlive.tlpdb

  #### additional symlinks
  getnonfreefonts.binlinks = {
    getnonfreefonts-sys = "getnonfreefonts";
  };

  ### missing licenses
  cjk-gs-integrate-macos.license = [ "gpl3Plus" ];

  fontsetup-nonfree.license = [ "gpl3" ];

  # actually 'LPPL 1.3 or later'
  getnonfreefonts.license = [ "lppl13a" ];

  hiraprop.license = [ "bsd3" ];

  japanese-otf-nonfree .license= [ "bsd3" ];

  # https://tug.ctan.org/fonts/LuxiMono/LICENSE
  # allows distributions but no modifications
  luxi.license = [ "unfreeRedistributable" ];

  # generic LPPL
  mkstmpdad.license = [ "lppl13c" ];

  ptex-fontmaps-macos.license = [ "publicDomain" ];

  spark-otf-fonts.license = [ "ofl" ];
}
