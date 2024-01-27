{ stdenv, lib, fetchurl, perl, gnused, dpkg, makeWrapper, autoPatchelfHook, libredirect }:

stdenv.mkDerivation rec {
  pname = "cups-brother-hll3230cdw";
  version = "1.0.2";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103925/hll3230cdwpdrv-${version}-0.i386.deb";
    sha256 = "9d49abc584bf22bc381510618a34107ead6ab14562b51831fefd6009947aa5a9";
  };

  nativeBuildInputs = [ dpkg makeWrapper autoPatchelfHook ];

  buildInputs = [ perl gnused libredirect ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -pr opt "$out"
    cp -pr usr/bin "$out/bin"
    rm "$out/opt/brother/Printers/hll3230cdw/cupswrapper/cupswrapperhll3230cdw"

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s "$out/opt/brother/Printers/hll3230cdw/cupswrapper/brother_lpdwrapper_hll3230cdw" \
      "$out/lib/cups/filter/brother_lpdwrapper_hll3230cdw"
    ln -s "$out/opt/brother/Printers/hll3230cdw/cupswrapper/brother_hll3230cdw_printer_en.ppd" \
      "$out/share/cups/model/brother_hll3230cdw_printer_en.ppd"

    runHook postInstall
  '';

  # Fix global references and replace auto discovery mechanism
  # with hardcoded values.
  #
  # The configuration binary 'brprintconf_hll3230cdw' and lpd filter
  # 'brhll3230cdwfilter' has hardcoded /opt format strings.  There isn't
  # sufficient space in the binaries to substitute a path in the store, so use
  # libredirect to get it to see the correct path.  The configuration binary
  # also uses this format string to print configuration locations.  Here the
  # wrapper output is processed to point into the correct location in the
  # store.

  postFixup = ''
    substituteInPlace $out/opt/brother/Printers/hll3230cdw/lpd/filter_hll3230cdw \
      --replace "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/hll3230cdw/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"hll3230cdw\"; #"

    substituteInPlace $out/opt/brother/Printers/hll3230cdw/cupswrapper/brother_lpdwrapper_hll3230cdw \
      --replace "PRINTER =~" "PRINTER = \"hll3230cdw\"; #" \
      --replace "my \$basedir = \`readlink \$0\`" "my \$basedir = \"$out/opt/brother/Printers/hll3230cdw/\""

    wrapProgram $out/bin/brprintconf_hll3230cdw \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $out/opt/brother/Printers/hll3230cdw/lpd/brhll3230cdwfilter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    substituteInPlace $out/bin/brprintconf_hll3230cdw \
      --replace \"\$"@"\" \"\$"@\" | LD_PRELOAD= ${gnused}/bin/sed -E '/^(function list :|resource file :).*/{s#/opt#$out/opt#}'"
  '';

  meta = with lib; {
    description = "Brother HL-L3230CDW printer driver";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ aplund ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    homepage = "http://www.brother.com/";
    downloadPage = "https://support.brother.com/g/b/downloadend.aspx?c=us&lang=en&prod=hll3230cdw_us_eu_as&os=128&dlid=dlf103925_000&flang=4&type3=10283";
  };
}
