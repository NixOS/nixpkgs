{ stdenv, fetchurl, cups, perl, brgenml1lpr, debugLvl ? "0"}:

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

        This is a non fatal issue. The job will still be printed. However, not sure
        what kind of information could be lost.

        There should be a more elegant way to patch this.

     2.  >  touch: cannot touch '/tmp/BrGenML1_latest_print_info': Permission denied

        TODO: Address.

     3.  >  perl: warning: Falling back to the standard locale ("C").
    
            are supported and installed on your system.
            LANG = "en_US.UTF-8"
            LC_ALL = (unset),
            LANGUAGE = (unset),
            perl: warning: Please check that your locale settings:
            perl: warning: Setting locale failed.

        TODO: Address.
*/

stdenv.mkDerivation rec {

  name = "brgenml1cupswrapper-3.1.0-1";
  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf101125/${name}.i386.deb";
    sha256 = "0kd2a2waqr10kfv1s8is3nd5dlphw4d1343srdsbrlbbndja3s6r";
  };

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  buildInputs = [ cups perl brgenml1lpr ];
  buildPhase = ":";

  patchPhase = ''
    WRAPPER=opt/brother/Printers/BrGenML1/cupswrapper/brother_lpdwrapper_BrGenML1
    PAPER_CFG=opt/brother/Printers/BrGenML1/cupswrapper/paperconfigml1  

    substituteInPlace $WRAPPER \
      --replace "basedir =~" "basedir = \"${brgenml1lpr}/opt/brother/Printers/BrGenML1\"; #" \
      --replace "PRINTER =~" "PRINTER = \"BrGenML1\"; #" \
      --replace "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    # Fixing issue #2.
    substituteInPlace $WRAPPER \
      --replace "\`cp " "\`cp -p " \
      --replace "\$TEMPRC\`" "\$TEMPRC; chmod a+rw \$TEMPRC\`" \
      --replace "\`mv " "\`cp -p "

    # This config script make this assumption that the *.ppd are found in a global location `/etc/cups/ppd`.
    substituteInPlace $PAPER_CFG \
      --replace "/etc/cups/ppd" "$out/share/cups/model"
  '';

  installPhase = ''
    CUPSFILTER=$out/lib/cups/filter
    CUPSPPD=$out/share/cups/model

    CUPSWRAPPER=opt/brother/Printers/BrGenML1/cupswrapper
    mkdir -p $out/$CUPSWRAPPER
    cp -rp $CUPSWRAPPER/* $out/$CUPSWRAPPER

    mkdir -p $CUPSFILTER
    ln -s $out/$CUPSWRAPPER/brother_lpdwrapper_BrGenML1 $CUPSFILTER

    mkdir -p $CUPSPPD
    ln -s $out/$CUPSWRAPPER/brother-BrGenML1-cups-en.ppd $CUPSPPD
  '';

  dontPatchELF = true;

  meta = {
    description = "Brother BrGenML1 CUPS wrapper driver";
    homepage = http://www.brother.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}
