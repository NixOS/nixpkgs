{stdenv, fetchurl, openssl
, guiSupport ? false
, qt4}:

assert !guiSupport || qt4 != null;

let
  buildDirs = "wpa_supplicant wpa_passphrase wpa_cli";
in

stdenv.mkDerivation rec {
  name = "wpa_supplicant-0.7.2";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "1gnwhnczli50gidsq22ya68hixmdrhd1sxw202ygihvg6xsjl06z";
  };

  preBuild = ''
    cd wpa_supplicant
    cp defconfig .config
    echo CONFIG_DEBUG_SYSLOG=y >> .config
    substituteInPlace Makefile --replace /usr/local $out
    makeFlagsArray=(ALL="${buildDirs} ${if guiSupport then "wpa_gui-qt4" else ""}")
  '';

  buildInputs = [openssl]
    ++ stdenv.lib.optional guiSupport qt4;

  # qt gui doesn't install because the executable is named differently from directory name
  # so never include wpa_gui_-qt4 in buildDirs when running make install
  preInstall = if guiSupport then ''
    makeFlagsArray=(ALL="${buildDirs}")
  '' else null;

  postInstall = ''
    ensureDir $out/share/man/man5 $out/share/man/man8
    cp doc/docbook/*.5 $out/share/man/man5/
    cp doc/docbook/*.8 $out/share/man/man8/
  ''
  + (if guiSupport then ''
      pwd
      cp wpa_gui-qt4/wpa_gui $out/sbin
    '' else "");

  meta = {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };

}
