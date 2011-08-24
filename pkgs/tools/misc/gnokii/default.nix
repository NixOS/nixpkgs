a :  
let 
  fetchurl = a.fetchurl;

  s = import ./src-for-default.nix; 
  buildInputs = with a; [
    perl intltool gettext libusb
    glib gtk pkgconfig bluez readline
    libXpm pcsclite libical
  ];
in

assert a.stdenv ? glibc;

rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = [ "doConfigure" "doMakeInstall"];

  inherit(s) name;
  meta = {
    description = "Cellphone tool";
    homepage = http://www.gnokii.org;
    maintainers = [a.lib.maintainers.raskin];
    platforms = with a.lib.platforms; linux;
  };
}
