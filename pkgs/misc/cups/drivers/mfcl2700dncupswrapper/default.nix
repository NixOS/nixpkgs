{ coreutils, dpkg, fetchurl, gnugrep, gnused, makeWrapper, mfcl2700dnlpr, perl, stdenv }:

stdenv.mkDerivation rec {
  name = "mfcl2700dncupswrapper-${meta.version}";

  src = fetchurl {
    url = "http://download.brother.com/welcome/dlf102086/${name}.i386.deb";
    sha256 = "07w48mah0xbv4h8vsh1qd5cd4b463bx8y6gc5x9pfgsxsy6h6da1";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfcl2700dnlpr}/opt/brother/Printers/MFCL2700DN
    dir=$out/opt/brother/Printers/MFCL2700DN

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_MFCL2700DN \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"MFCL2700DN\"; #"

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_MFCL2700DN \
      --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gnugrep gnused ]}

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/brother_lpdwrapper_MFCL2700DN $out/lib/cups/filter
    ln $dir/cupswrapper/brother-MFCL2700DN-cups-en.ppd $out/share/cups/model
  '';

  meta = {
    description = "Brother MFC-L2700DN CUPS wrapper driver";
    homepage = http://www.brother.com/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.linux;
    version = "3.2.0-1";
  };
}
