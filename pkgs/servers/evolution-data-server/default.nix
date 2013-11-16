x@{builderDefsPackage
  , pkgconfig, flex, bison, libtool, intltool, perl
  , db4, krb5, openldap, glib, libxml2, GConf
  , nss, gtk, libgnome, libsoup, gnome_keyring
  , gtkdoc, sqlite, libgweather, libical, icu
  , dbus_glib, gperf, nspr, gmp, nettle, libgdata_0_6
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    url = "mirror://gnome/sources/evolution-data-server/2.32/evolution-data-server-2.32.3.tar.bz2";
    hash = "744026a745b711b3e393b61fed21c4926d1b10a3aa7da64f4b33a3e3bf5b085c";
    version = "2.32.3";
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
    broken = true;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://projects.gnome.org/evolution/download.shtml";
    };
  };
}) x

