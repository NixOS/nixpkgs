x@{builderDefsPackage
  , python, gtk, pygtk, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
  , libffi, cyrus_sasl, intltool, perl, perlPackages, firefox36Pkgs
  , kbproto, libX11, libXext, xextproto, pygobject, libgcrypt
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["perlPackages" "firefox36Pkgs" "gtkLibs"];

  buildInputs = (map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames)))
    ++ [perlPackages.TextCSV firefox36Pkgs.xulrunner ];
  sourceInfo = rec {
    baseName="gtk-vnc";
    majorVersion="0.4";
    minorVersion="2";
    version="${majorVersion}.${minorVersion}";
    name="${baseName}-${version}";
    url="mirror://gnome/sources/${baseName}/${majorVersion}/${name}.tar.gz";
    hash="1fkhzwpw50rnwp51lsbny16p2ckzx5rkcaiaqvkd90vwnm2cccls";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  configureFlags = [
    "--with-python"
    "--with-examples"
  ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixMakefiles" "doConfigure" "doMakeInstall"];

  fixMakefiles = a.fullDepEntry ''
    find . -name 'Makefile*' -exec sed -i '{}' -e 's@=codegendir pygtk-2.0@=codegendir pygobject-2.0@' ';'
  '' ["minInit" "doUnpack"];
      
  meta = {
    description = "A GTK VNC widget";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.lgpl21;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/gtk-vnc";
    };
  };
}) x

