{ lib, stdenv, fetchurl, makeWrapper, cups, perl, coreutils, gnused, gnugrep
, brgenml1lpr, debugLvl ? "0"}:

/*
    [Setup instructions](http://support.brother.com/g/s/id/linux/en/instruction_prn1a.html).

    URI example
     ~  `lpd://BRW0080927AFBCE/binary_p1`

    Logging
    -------

    `/tmp/br_cupswrapper_ml1.log` when `DEBUG > 0` in `brother_lpdwrapper_BrGenML1`.
    Note that when `DEBUG > 1` the wrapper stops performing its function. Better
    keep `DEBUG == 1` unless this is desirable.

    Now activable through this package's `debugLvl` parameter whose value is to be
    used to establish `DEBUG`.

    Issues
    ------

     1.  >  Error: /tmp/brBrGenML1rc_15642 :cannot open file !!

        Fixed.

     2.  >  touch: cannot touch '/tmp/BrGenML1_latest_print_info': Permission denied

        Fixed.

     3.  >  perl: warning: Falling back to the standard locale ("C").

            are supported and installed on your system.
            LANG = "en_US.UTF-8"
            LC_ALL = (unset),
            LANGUAGE = (unset),
            perl: warning: Please check that your locale settings:
            perl: warning: Setting locale failed.

        TODO: Address.

     4. Since nixos 16.03 release, in `brother_lpdwrapper_BrGenML1`:

        > sh: grep: command not found
          sh: chmod: command not found
          sh: cp: command not found
          Error: /tmp/brBrGenML1rc_1850 :cannot open file !!
          sh: sed: command not found

        Fixed by use of a wrapper that brings `coreutils`, `gnused`, `gnugrep`
        in `PATH`.
*/

stdenv.mkDerivation rec {
  pname = "brgenml1cupswrapper";
  version = "3.1.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf101125/brgenml1cupswrapper-${version}.i386.deb";
    sha256 = "0kd2a2waqr10kfv1s8is3nd5dlphw4d1343srdsbrlbbndja3s6r";
  };

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups perl coreutils gnused gnugrep brgenml1lpr ];

  dontBuild = true;

  patchPhase = ''
    WRAPPER=opt/brother/Printers/BrGenML1/cupswrapper/brother_lpdwrapper_BrGenML1
    PAPER_CFG=opt/brother/Printers/BrGenML1/cupswrapper/paperconfigml1

    substituteInPlace $WRAPPER \
      --replace "basedir =~" "basedir = \"${brgenml1lpr}/opt/brother/Printers/BrGenML1\"; #" \
      --replace "PRINTER =~" "PRINTER = \"BrGenML1\"; #" \
      --replace "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    # Fixing issue #1 and #2.
    substituteInPlace $WRAPPER \
      --replace "\`cp " "\`cp -p " \
      --replace "\$TEMPRC\`" "\$TEMPRC; chmod a+rw \$TEMPRC\`" \
      --replace "\`mv " "\`cp -p "

    # This config script make this assumption that the *.ppd are found in a global location `/etc/cups/ppd`.
    substituteInPlace $PAPER_CFG \
      --replace "/etc/cups/ppd" "$out/share/cups/model"
  '';


  installPhase = ''
    CUPSFILTER_DIR=$out/lib/cups/filter
    CUPSPPD_DIR=$out/share/cups/model
    CUPSWRAPPER_DIR=opt/brother/Printers/BrGenML1/cupswrapper

    mkdir -p $out/$CUPSWRAPPER_DIR
    cp -rp $CUPSWRAPPER_DIR/* $out/$CUPSWRAPPER_DIR

    mkdir -p $CUPSFILTER_DIR
    # Fixing issue #4.
    makeWrapper \
      $out/$CUPSWRAPPER_DIR/brother_lpdwrapper_BrGenML1 \
      $CUPSFILTER_DIR/brother_lpdwrapper_BrGenML1 \
      --prefix PATH : ${coreutils}/bin \
      --prefix PATH : ${gnused}/bin \
      --prefix PATH : ${gnugrep}/bin

    mkdir -p $CUPSPPD_DIR
    ln -s $out/$CUPSWRAPPER_DIR/brother-BrGenML1-cups-en.ppd $CUPSPPD_DIR
  '';

  dontPatchELF = true;
  dontStrip = true;

  meta = {
    description = "Brother BrGenML1 CUPS wrapper driver";
    homepage = "http://www.brother.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
}
