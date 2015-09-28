a @ { groff, ... } :
let
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2.17" a;
  buildInputs = with a; [
    groff
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/setserial/setserial-${version}.tar.gz";
    sha256 = "0jkrnn3i8gbsl48k3civjmvxyv9rbm1qjha2cf2macdc439qfi3y";
  };

  inherit buildInputs;
  configureFlags = [];

  installFlags = "DESTDIR=$out";

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "patchPath" "doMakeInstall"];

  patchPath = a.fullDepEntry (''
    sed -e s@/usr/man/@/share/man/@ -i Makefile
  '') ["minInit" "doUnpack" "doConfigure"];

  neededDirs = ["$out/bin" "$out/share/man/man8"];

  name = "setserial-" + version;
  meta = {
    description = "Serial port configuration utility";
  };
}
