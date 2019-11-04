{ pkgsi686Linux, stdenv, fetchurl, dpkg, makeWrapper }:

let
  pdrv = stdenv.mkDerivation rec {
    name = "dcpj1100dwpdrv-${version}";
    version = "1.0.5-0";
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf103809/dcpj1100dwpdrv-${version}.i386.deb";
      sha256 = "0i34p0cfmv05w1y1f8fj88qjira094cyh7y5im22i1dg6002ib85";
    };
    nativeBuildInputs = [ dpkg ];
    phases = [ "installPhase" ];
    installPhase = "dpkg-deb -x $src $out";
  };
  fhsEnv = pkgsi686Linux.buildFHSUserEnv {
    name = "dcpj1100dwpdrv-fhs-env";
    targetPkgs = pkgs: [ pdrv pkgs.perl pkgs.file pkgs.which pkgs.ghostscript ];
    extraBuildCommands = "ln -s ${pdrv}/opt $out/opt";
    runScript = "/opt/brother/Printers/dcpj1100dw/lpd/filter_dcpj1100dw";
  };
in
stdenv.mkDerivation rec {
  name = "dcpj1100dw-cups-${version}";
  version = "1.0.5-0";

  nativeBuildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/cups/model
    ln -s ${pdrv}/opt/brother/Printers/dcpj1100dw/cupswrapper/brother_dcpj1100dw_printer_en.ppd \
      $out/share/cups/model/

    makeWrapper ${fhsEnv}/bin/dcpj1100dwpdrv-fhs-env \
      $out/lib/cups/filter/brother_lpdwrapper_dcpj1100dw
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.brother.com/";
    description = "Brother DCP-J1100DW combined print driver";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "i686-linux" ];
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=au&lang=en&prod=dcpj1100dw_eu_as&os=128";
    maintainers = [ maintainers.puffnfresh ];
  };
}
