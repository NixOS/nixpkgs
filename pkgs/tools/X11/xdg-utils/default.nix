{ stdenv, fetchgit, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, which, gnugrep, gnused, coreutils }:

stdenv.mkDerivation rec {
  name = "xdg-utils-1.1.0-rc3p7";

  src = fetchgit {
    url = "http://anongit.freedesktop.org/git/xdg/xdg-utils.git";
    rev = "e8ee3b18d16e41b95148111b920a0c8beed3ac6c";
    sha256 = "0qy9h7vh6sw7wmadjvasw4sdhb9fvv7bn32ifgasdx7ag3r3939w";
  };

  # just needed when built from git
  buildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = ''
    for item in $out/bin/*; do
      substituteInPlace $item --replace "cut " "${coreutils}/bin/cut "
      substituteInPlace $item --replace "sed " "${gnused}/bin/sed "
      substituteInPlace $item --replace "grep " "${gnugrep}/bin/grep "
      substituteInPlace $item --replace "egrep " "${gnugrep}/bin/egrep "
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

