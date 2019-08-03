{ coreutils, dpkg, fetchurl, gnugrep, gnused, makeWrapper,
mfcl8690cdwlpr, perl, stdenv}:

stdenv.mkDerivation rec {
  name = "mfcl8690cdwcupswrapper-${version}";
  version = "1.4.0-0";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf103250/${name}.i386.deb";
    sha256 = "1bl9r8mmj4vnanwpfjqgq3c9lf2v46wp5k6r2n9iqprf7ldd1kb2";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfcl8690cdwlpr}/opt/brother/Printers/mfcl8690cdw
    dir=$out/opt/brother/Printers/mfcl8690cdw

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcl8690cdw\"; #"

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfcl8690cdw_printer_en.ppd $out/share/cups/model
    '';

  meta = {
    description = "Brother MFC-L8690CDW CUPS wrapper driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.fuzzy-id ];
  };
}
