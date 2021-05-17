{ lib, stdenv, fetchurl, makeWrapper, cups, perl, coreutils, gnused, gnugrep, pkgs, mfcj430wlpr }:

stdenv.mkDerivation rec {
  pname = "mfcj430w-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006803/mfcj430wcupswrapper-src-${version}.tar.gz";
    sha256 = "1gryrjx5cbfzrzf6qvbbqnprs3zrkmzvrrbggjy09f8apa2c5dlb";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups perl coreutils gnused gnugrep mfcj430wlpr ];

  patchPhase = ''
    WRAPPER=cupswrapper/cupswrappermfcj430w

    substituteInPlace $WRAPPER \
    --replace /opt "${mfcj430wlpr}/opt" \
    --replace /usr "${mfcj430wlpr}/usr" \
    --replace /etc "$out/etc"

    substituteInPlace $WRAPPER \
    --replace "\`cp " "\`cp -p " \
    --replace "\`mv " "\`cp -p "
  '';

  buildPhase = ''
    cd brcupsconfig
    make all
    cd ..
  '';

  installPhase = ''
    TARGETFOLDER=$out/opt/brother/Printers/mfcj430w/cupswrapper/
    CUPSPPD_DIR=$out/share/cups/model
    CUPSFILTER_DIR=$out/lib/cups/filter

    mkdir -p $TARGETFOLDER

    cp brcupsconfig/brcupsconfpt1 $TARGETFOLDER
    cp cupswrapper/cupswrappermfcj430w $TARGETFOLDER/
    cp ppd/brother_mfcj430w_printer_en.ppd $TARGETFOLDER/

    mkdir -p $CUPSPPD_DIR
    ln -s $TARGETFOLDER/brother_mfcj430w_printer_en.ppd $CUPSPPD_DIR
  '';

  cleanPhase = ''
    cd brcupsconfig
    make clean
  '';

  meta = with lib; {
    homepage = "https://www.brother.com/";
    description = "Brother MFC-J430W CUPS wrapper driver";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj430w_all&os=128&autolayerclose=1";
    maintainers = with maintainers; [ svavs ];
  };
}
