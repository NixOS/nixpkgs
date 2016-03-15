{ stdenv, fetchurl, cups, perl, glibc, ghostscript, which, makeWrapper}:

/*
    [Setup instructions](http://support.brother.com/g/s/id/linux/en/instruction_prn1a.html).

    URI example
     ~  `lpd://BRW0080927AFBCE/binary_p1`

    Logging
    -------
    
    `/tmp/br_lpdfilter_ml1.log` when `$ENV{LPD_DEBUG} > 0` in `filter_BrGenML1`
    which is activated automatically when `DEBUG > 0` in `brother_lpdwrapper_BrGenML1`
    from the cups wrapper.

    Issues
    ------

     -  filter_BrGenML1 ln 196 `my $GHOST_SCRIPT=`which gs`;`
      
        `GHOST_SCRIPT` is empty resulting in an empty `/tmp/br_lpdfilter_ml1_gsout.dat` file.
        See `/tmp/br_lpdfilter_ml1.log` for the executed command.

    Notes
    -----

     -  The `setupPrintcap` has totally no use in our context.
*/

let
  myPatchElf = file: with stdenv.lib; ''
    patchelf --set-interpreter \
      ${stdenv.glibc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';
in
stdenv.mkDerivation rec {

  name = "brgenml1lpr-3.1.0-1";
  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf101123/${name}.i386.deb";
    sha256 = "0zdvjnrjrz9sba0k525linxp55lr4cyivfhqbkq1c11br2nvy09f";
  };

  unpackPhase = ''
    ar x $src
    tar xfvz data.tar.gz
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups perl glibc ghostscript which ];
  
  buildPhase = ":";

  patchPhase = ''
    INFDIR=opt/brother/Printers/BrGenML1/inf
    LPDDIR=opt/brother/Printers/BrGenML1/lpd

    # Setup max debug log by default.
    substituteInPlace $LPDDIR/filter_BrGenML1 \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/BrGenML1\"; #" \
      --replace "PRINTER =~" "PRINTER = \"BrGenML1\"; #"

    ${myPatchElf "$INFDIR/braddprinter"}
    ${myPatchElf "$LPDDIR/brprintconflsr3"}
    ${myPatchElf "$LPDDIR/rawtobr3"}
  '';

  installPhase = ''
    INFDIR=opt/brother/Printers/BrGenML1/inf
    LPDDIR=opt/brother/Printers/BrGenML1/lpd

    mkdir -p $out/$INFDIR
    cp -rp $INFDIR/* $out/$INFDIR
    mkdir -p $out/$LPDDIR
    cp -rp $LPDDIR/* $out/$LPDDIR

    wrapProgram $out/$LPDDIR/filter_BrGenML1 \
      --prefix PATH ":" "${ghostscript}/bin" \
      --prefix PATH ":" "${which}/bin"
  '';

  dontPatchELF = true;


  meta = {
    description = "Brother BrGenML1 LPR driver";
    homepage = http://www.brother.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}
