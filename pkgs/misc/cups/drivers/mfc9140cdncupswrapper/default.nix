{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, coreutils
, gnugrep
, gnused
, mfc9140cdnlpr
, pkgsi686Linux
, psutils
}:

stdenv.mkDerivation rec {
  pname = "mfc9140cdncupswrapper";
  version = "1.1.4-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100407/${pname}-${version}.i386.deb";
    sha256 = "18aramgqgra1shdhsa75i0090hk9i267gvabildwsk52kq2b96c6";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    lpr=${mfc9140cdnlpr}/opt/brother/Printers/mfc9140cdn
    dir=$out/opt/brother/Printers/mfc9140cdn

    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/cupswrapper/brcupsconfpt1"

    substituteInPlace $dir/cupswrapper/cupswrappermfc9140cdn \
      --replace "mkdir -p /usr" ": # mkdir -p /usr" \
      --replace '/opt/brother/''${device_model}/''${printer_model}/lpd/filter''${printer_model}' "$lpr/lpd/filtermfc9140cdn" \
      --replace '/usr/share/ppd/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9140cdn_printer_en.ppd" \
      --replace '/usr/share/cups/model/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9140cdn_printer_en.ppd" \
      --replace '/opt/brother/Printers/''${printer_model}/' "$lpr/" \
      --replace 'nup="psnup' "nup=\"${psutils}/bin/psnup" \
      --replace '/usr/bin/psnup' "${psutils}/bin/psnup"

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/cupswrappermfc9140cdn $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfc9140cdn_printer_en.ppd $out/share/cups/model

    sed -n '/!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' "$dir/cupswrapper/cupswrappermfc9140cdn" | sed '1 br; b; :r s/.*/printer_model=mfc9140cdn; cat <<!ENDOFWFILTER!/'  | bash > $out/lib/cups/filter/brother_lpdwrapper_mfc9140cdn
    sed -i "/#! \/bin\/sh/a PATH=${lib.makeBinPath [ coreutils gnused gnugrep ]}:\$PATH" $out/lib/cups/filter/brother_lpdwrapper_mfc9140cdn
    chmod +x $out/lib/cups/filter/brother_lpdwrapper_mfc9140cdn
    '';

  meta = with lib; {
    description = "Brother MFC-9140CDN CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
