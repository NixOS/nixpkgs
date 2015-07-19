{ stdenv, fetchzip, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, which, gnugrep, gnused, coreutils }:

stdenv.mkDerivation rec {
  name = "xdg-utils-1.1.0-rc3p7";

  src = fetchzip {
    name = "${name}.tar.gz";
    url = "http://cgit.freedesktop.org/xdg/xdg-utils/snapshot/e8ee3b18d16e4.tar.gz";
    sha256 = "1hz6rv45blcii1a8n1j45rg8vzm98vh4fvlca3zmay1kp57yr4jl";
  };

  # just needed when built from git
  buildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = ''
    for item in $out/bin/*; do
      substituteInPlace $item --replace "cut " "${coreutils}/bin/cut "
      substituteInPlace $item --replace "sed " "${gnused}/bin/sed "
      substituteInPlace $item --replace "egrep " "${gnugrep}/bin/egrep "
      sed -i $item -re "s#([^e])grep #\1${gnugrep}/bin/grep #g" # Don't replace 'egrep'
      substituteInPlace $item --replace "which " "${which}/bin/which "
      substituteInPlace $item --replace "/usr/bin/file" "${file}/bin/file"
    done
  '';

  meta = {
    homepage = http://portland.freedesktop.org/wiki/;
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}

