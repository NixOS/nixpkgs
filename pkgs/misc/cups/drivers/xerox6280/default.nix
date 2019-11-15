{ stdenv, rpm, cpio} :
stdenv.mkDerivation {
  pname = "Xerox-Phaser-6280";
  version = "1.0.0.0";

  buildInputs = [rpm cpio];

  src = fetchTarball {
    url = "http://download.support.xerox.com/pub/drivers/6280/drivers/linux/en/6280_Linux.tar";
    sha256 = "1xkawpj697bv82rd1f31nfs5bfq58jsgni5zq1cvqnn7layifv24";
  };

  postUnpack = ''
    (
    cd source
    rpm2cpio English/Xerox-Phaser-6280-1.0-1.noarch.rpm | cpio -idmv
    )
  '';

  installPhase = ''
    mkdir -p $out
    mv usr/share $out/
  '';


  meta = with stdenv.lib; {
    homepage = https://www.xerox.com/;
    description = "Print drivers for Xerox Phaser 6280 (DN/DT/N)";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    downloadPage = "https://www.support.xerox.com/support/phaser-6280/downloads/enus.html?operatingSystem=linux&fileLanguage=en";
    maintainers = [ maintainers.twistedjoe ];
  };
}
