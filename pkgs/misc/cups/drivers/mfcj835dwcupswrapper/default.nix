{ stdenv, fetchurl, mfcj835dwlpr, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "mfcj835dw-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006818/mfcj835dwcupswrapper-src-${version}.tar.gz";
    sha256 = "0gwpp46cvlq11lcszxqv6qvyjrrbp2hxdq34nb25gs8dnb21zic2";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mfcj835dwlpr ];

  buildPhase = ''
    cd brcupsconfig
    make all
    cd ..
    '';

  installPhase = ''
    TARGETFOLDER=$out/opt/brother/Printers/mfcj835dw/cupswrapper
    mkdir -p $TARGETFOLDER
    cp ppd/brother_mfcj835dw_printer_en.ppd $TARGETFOLDER
    cp brcupsconfig/brcupsconfpt1 $TARGETFOLDER
    cp cupswrapper/cupswrappermfcj835dw $TARGETFOLDER
    sed -i -e '26,304d' $TARGETFOLDER/cupswrappermfcj835dw
    substituteInPlace $TARGETFOLDER/cupswrappermfcj835dw \
      --replace "\$ppd_file_name" "$TARGETFOLDER/brother_mfcj835dw_printer_en.ppd"

    CPUSFILTERFOLDER=$out/lib/cups/filter
    mkdir -p $TARGETFOLDER $CPUSFILTERFOLDER
    ln -s ${mfcj835dwlpr}/lib/cups/filter/brother_lpdwrapper_mfcj835dw $out/lib/cups/filter/brother_lpdwrapper_mfcj835dw
    ##TODO: Use the cups filter instead of the LPR one.
    #cp scripts/cupswrappermfcj835dw $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw
    #sed -i -e '110,258!d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw
    #sed -i -e '33,40d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw
    #sed -i -e '34,35d' $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw
    #substituteInPlace $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw \
    #  --replace "/opt/brother/$``{device_model``}/$``{printer_model``}/lpd/filter$``{printer_model``}" \
    #    "${mfcj835dwlpr}/opt/brother/Printers/mfcj835dw/lpd/filtermfcj835dw" \
    #  --replace "/opt/brother/Printers/$``{printer_model``}/inf/br$``{printer_model``}rc" \
    #    "${mfcj835dwlpr}/opt/brother/Printers/mfcj835dw/inf/brmfcj835dwrc" \
    #  --replace "/opt/brother/$``{device_model``}/$``{printer_model``}/cupswrapper/brcupsconfpt1" \
    #    "$out/opt/brother/Printers/mfcj835dw/cupswrapper/brcupsconfpt1" \
    #  --replace "/usr/share/cups/model/Brother/brother_" "$out/opt/brother/Printers/mfcj835dw/cupswrapper/brother_"
    #substituteInPlace $CPUSFILTERFOLDER/brother_lpdwrapper_mfcj835dw \
    #  --replace "$``{printer_model``}" "mfcj835dw" \
    #  --replace "$``{printer_name``}" "MFCJ835DW"
    '';

  cleanPhase = ''
    cd brcupsconfpt1
    make clean
    '';

  meta = with stdenv.lib; {
    homepage = http://www.brother.com/;
    description = "Brother MFC-J835DW CUPS wrapper driver";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    downloadPage = https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj835dw_us&os=128;
    maintainers = with maintainers; [ alexander-c-b ];
  };
}
