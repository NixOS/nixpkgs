{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  perl,
  cups,
  perl,
  ghostscript,
  which,
  gnused,
  gnugrep,
  coreutils-full,
}:
let
  # I tried to keep this generic as possible
  MODEL = "mfcj4540dw";
  VERSION = "3.5.0-1";
  PRINTERS_DIR = "opt/brother/Printers";
  ARCH = builtins.elemAt (lib.splitString "-" stdenv.hostPlatform.system) 0;
  INFDIR = "${PRINTERS_DIR}/${MODEL}/inf";
  LPDDIR = "${PRINTERS_DIR}/${MODEL}/lpd";
  CUPSWRAPPER = "${PRINTERS_DIR}/${MODEL}/cupswrapper";
  debugLvl = "0"; # Once you're done debugging (whatever cups is invoking produces output on stdout) set this to 0
in
stdenv.mkDerivation rec {
  pname = MODEL;
  version = VERSION;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105305/${MODEL}pdrv-${VERSION}.i386.deb";
    hash = "sha256-pdo/UWsAdZeebSXD9tReiA73qkhuclzt/CDXy50NunQ=";
  };

  unpackPhase = ''
    dpkg -x $src .
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
    perl
  ];

  buildInputs = [
    cups
    perl
    stdenv.cc.libc
    ghostscript
    which
    gnused
    gnugrep
    coreutils-full
  ];

  dontBuild = true;

  patchPhase = ''
    WRAPPER=${CUPSWRAPPER}/brother_lpdwrapper_${MODEL}

    substituteInPlace $WRAPPER \
      --replace-fail "basedir =~" "basedir = \"$out/${PRINTERS_DIR}/${MODEL}\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"${MODEL}\"; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};" \
      --replace-fail 'my $LPDFILTER   =$basedir."lpd/filter_".$PRINTER;' 'my $LPDFILTER   =$basedir."/lpd/filter_".$PRINTER;'

    # Fixing issue #1 and #2.
    substituteInPlace $WRAPPER \
      --replace-fail "\`cp " "\`cp -p " \
      --replace-fail "\$TEMPRC\`" "\$TEMPRC; chmod a+rw \$TEMPRC\`" \
      --replace-fail "\`mv " "\`cp -p "

    substituteInPlace ${INFDIR}/setupPrintcapij \
      --replace-fail "/etc/printcap" "$out/etc/printcap" \
      --replace-fail "/${PRINTERS_DIR}" "$out/${PRINTERS_DIR}" \
      --replace-fail "/var/spool/lpd" "$out/var/spool/lpd"

    substituteInPlace ${CUPSWRAPPER}/cupswrapper${MODEL} \
      --replace-fail "/usr/share" "$out/share"

    substituteInPlace ${LPDDIR}/filter_${MODEL} \
      --replace-fail 'PRINTER =~' 'PRINTER = "${MODEL}"; #'\
      --replace-fail "BR_PRT_PATH =~ " "BR_PRT_PATH = \"$out/${PRINTERS_DIR}/${MODEL}\"; #"\
      --replace-fail "my \$BRCONV=" "my \$BRCONV=\"$out/${LPDDIR}/br${MODEL}filter\"; #"\
      --replace-fail "\$PAPERINF=" "\$PAPERINF=\"$out/${INFDIR}/paperinfij2\" ;#"\
      --replace-fail "\$IMAGABLE=" "\$IMAGABLE=\"$out/${INFDIR}/ImagingArea\" ;#"

    perl -pi -e 's|/opt/brother/Printers/|lopt/brother/Printers/|g' ${LPDDIR}/${ARCH}/br${MODEL}filter
    perl -pi -e 's|/opt/brother/Printers/|lopt/brother/Printers/|g' ${LPDDIR}/${ARCH}/brprintconf_${MODEL}
  '';

  installPhase = ''
    CUPSFILTER_DIR=$out/lib/cups/filter
    CUPSPPD_DIR=$out/share/cups/model

    mkdir -p $out
    cp -rp ./opt $out/
    mkdir -p $out/var/spool/lpd $out/etc $out/share $out/bin $CUPSFILTER_DIR $CUPSPPD_DIR
    ln -s $out/opt $out/lopt

    # Fixing issue #4.
    makeWrapper \
      $out/${CUPSWRAPPER}/brother_lpdwrapper_${MODEL} \
      $CUPSFILTER_DIR/brother_lpdwrapper_${MODEL} \
      --prefix PATH : ${coreutils}/bin \
      --prefix PATH : ${gnused}/bin \
      --prefix PATH : ${gnugrep}/bin

    ln -s $out/${CUPSWRAPPER}/brother_${MODEL}_printer_en.ppd $CUPSPPD_DIR

    wrapProgram $out/${LPDDIR}/filter_${MODEL} \
      --prefix PATH ":" "${ghostscript}/bin" \
      --prefix PATH ":" "${which}/bin"

    # postinst:4
    mkdir -p $out/${LPDDIR}
    makeWrapper $out/${LPDDIR}/${ARCH}/br${MODEL}filter \
      $out/${LPDDIR}/br${MODEL}filter \
       --chdir $out

    makeWrapper $out/${LPDDIR}/${ARCH}/brprintconf_${MODEL} \
      $out/${LPDDIR}/brprintconf_${MODEL} \
      --chdir $out

    # postinst:11
    $out/${INFDIR}/setupPrintcapij ${MODEL} -i
    # postinst:12
    $out/${CUPSWRAPPER}/cupswrapper${MODEL}

    # postinst:14-22 selinux stuff I couldn't bother with
    # postinst:23
    ln -s $out/${LPDDIR}/brprintconf_${MODEL} $out/bin/brprintconf_${MODEL}
  '';

  dontPatchELF = true;

  meta = {
    description = "Brother MFC-J4540DW driver";
    downloadPage = "https://www.brother.com.au/en/support/mfc-j4540dw/downloads";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; unfree;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
