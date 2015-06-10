{ stdenv, fetchzip, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto, w3m }:

let rev = "e8ee3b18d16e41b95148111b920a0c8beed3ac6c"; in

stdenv.mkDerivation rec {
  name = "xdg-utils-1.1.0-rc3p7";

  src = fetchzip {
    name = "xdg-utils-${rev}.tar.gz";
    url = "http://cgit.freedesktop.org/xdg/xdg-utils/snapshot/${rev}.tar.gz";
    sha256 = "1hz6rv45blcii1a8n1j45rg8vzm98vh4fvlca3zmay1kp57yr4jl";
  };

  # just needed when built from git
  buildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = ''
    substituteInPlace $out/bin/xdg-mime --replace /usr/bin/file ${file}/bin/file
  '';

  meta = {
    homepage = http://portland.freedesktop.org/wiki/;
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = stdenv.lib.licenses.free;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}

