x@{builderDefsPackage
  , pkgconfig, flex, bison, libtool, intltool, perl
  , db4, krb5, openldap, glib, libxml2, GConf
  , nss, gtk, libgnome, libsoup, gnome_keyring
  , gtkdoc, sqlite, libgweather, libical, icu
  , dbus_glib, gperf, nspr, gdk_pixbuf ? null
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    url = "mirror://gnome/sources/evolution-data-server/2.30/evolution-data-server-2.30.3.tar.bz2";
    hash = "147qkpiafrlq220qg2pmp9lbvh8bn339wh1699bgb7rvmdvycwrp";
    version = "2.30.3";
    name = "evolution-data-server-${version}";
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
  phaseNames = ["doConfigure" "doMakeInstall"];

  configureFlags = [
    "--with-nspr-includes=${nspr}/include/nspr"
    "--with-nss-includes=${nss}/include/nss"
  ];
      
  meta = {
    description = "Evolution Data Server";
    maintainers = with a.lib.maintainers;
    [
      /* I am only interested in it for libebook... */
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://projects.gnome.org/evolution/download.shtml";
    };
  };
}) x

