{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  pname = "philter";
  version = "1.1";
  src = fetchurl {
    url = "mirror://sourceforge/philter/${pname}-${version}.tar.gz";
    sha256 = "177pqfflhdn2mw9lc1wv9ik32ji69rjqr6dw83hfndwlsva5151l";
  };

  installPhase = ''
    mkdir -p "$out"/{bin,share/philter}
    cp .philterrc "$out"/share/philter/philterrc
    sed -i 's@/usr/local/bin@${python2}/bin@' src/philter.py
    cp src/philter.py "$out"/bin/philter
    chmod +x "$out"/bin/philter
  '';

  meta = with lib; {
    description = "Mail sorter for Maildirs";
    homepage = "http://philter.sourceforge.net";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://philter.sourceforge.net/";
    };
  };
}
