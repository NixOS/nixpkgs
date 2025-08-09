{
  lib,
  stdenv,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  coreutils,
  perl,
  gnugrep,
  which,
  debugLvl ? "0",
}:

let
  version = "3.2.0-1";
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf102692/hl2260dlpr-${version}.i386.deb";
    hash = "sha256-R+cM2SKc/MP6keo3PUrKXPC6a2dEQQdBunrpNtAHlH0=";
  };

  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf102693/hl2260dcupswrapper-${version}.i386.deb";
    hash = "sha256-k6+ulZVoFTpEY6WJ9TO9Rzp2c4dwPqL3NY5/XYJpvOc=";
  };
in
stdenv.mkDerivation {
  pname = "cups-brother-hl2260d";
  inherit version;

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];
  buildInputs = [
    cups
    ghostscript
    perl
  ];

  dontPatchELF = true;
  dontBuild = true;

  unpackPhase = ''
    mkdir -p $out
    dpkg-deb -x ${cupsdeb} $out
    dpkg-deb -x ${lprdeb} $out
  '';

  patchPhase = ''
    # Patch lpr
    INFDIR=$out/opt/brother/Printers/HL2260D/inf
    LPDDIR=$out/opt/brother/Printers/HL2260D/lpd

    substituteInPlace $LPDDIR/filter_HL2260D \
      --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/HL2260D\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HL2260D\"; #"

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $INFDIR/braddprinter
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconflsr3
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/rawtobr3

    # Patch cupswrapper
    WRAPPER=$out/opt/brother/Printers/HL2260D/cupswrapper/brother_lpdwrapper_HL2260D
    PAPER_CFG=$out/opt/brother/Printers/HL2260D/cupswrapper/paperconfigml1

    substituteInPlace $WRAPPER \
      --replace "basedir =~" "basedir = \"$out/opt/brother/Printers/HL2260D\"; #" \
      --replace "PRINTER =~" "PRINTER = \"HL2260D\"; #" \
      --replace "\$DEBUG=0;" "\$DEBUG=${debugLvl};"
    substituteInPlace $WRAPPER \
      --replace "\`cp " "\`cp -p " \
      --replace "\$TEMPRC\`" "\$TEMPRC; chmod a+rw \$TEMPRC\`" \
      --replace "\`mv " "\`cp -p "
    # This config script make this assumption that the *.ppd are found in a global location `/etc/cups/ppd`.
    substituteInPlace $PAPER_CFG \
      --replace "/etc/cups/ppd" "$out/share/cups/model"
  '';

  installPhase = ''
    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HL2260D/cupswrapper/brother-HL2260D-cups-en.ppd $out/share/cups/model

    mkdir -p $out/lib/cups/filter/
    makeWrapper \
      $out/opt/brother/Printers/HL2260D/cupswrapper/brother_lpdwrapper_HL2260D \
      $out/lib/cups/filter/brother_lpdwrapper_HL2260D \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    wrapProgram $out/opt/brother/Printers/HL2260D/lpd/filter_HL2260D \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          which
        ]
      }
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother HL-2260D printer driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=cn_ot&lang=en&prod=hl2260d_cn";
    maintainers = with maintainers; [ u2x1 ];
  };
}
