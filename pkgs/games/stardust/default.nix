x@{builderDefsPackage
  , zlib, libtiff, libxml2, SDL, xproto, libX11, libXi, inputproto, libXmu
  , libXext, xextproto, mesa
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="stardust";
    version="0.1.13";
    name="${baseName}-${version}";
    url="http://iwar.free.fr/IMG/gz/${name}.tar.gz";
    hash="19rs9lz5y5g2yiq1cw0j05b11digw40gar6rw8iqc7bk3s8355xp";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "fixPaths" "doMakeInstall"];

  configureFlags = [
    "--bindir=$out/bin"
    "--datadir=$out/share"
  ];
  
  makeFlags = [
    "bindir=$out/bin"
    "datadir=$out/share"
  ];

  fixPaths = a.fullDepEntry (''
    sed -e "s@#define PACKAGE .*@#define PACKAGE \"stardust\"@" -i config.h
  '') ["minInit"];

  meta = {
    description = "Space flight simulator";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://iwar.free.fr/article.php3?id_article=6";
    };
  };
}) x

