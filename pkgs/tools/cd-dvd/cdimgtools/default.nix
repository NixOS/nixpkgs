{ lib, stdenv, fetchFromRepoOrCz, autoreconfHook, makeWrapper, libdvdcss, libdvdread, perl, perlPackages, asciidoc, xmlto, sourceHighlight, docbook_xsl, docbook_xml_dtd_45 }:

stdenv.mkDerivation {
  pname = "cdimgtools";
  version = "0.3";

  src = fetchFromRepoOrCz {
    repo = "cdimgtools";
    rev = "version/0.3";
    sha256 = "1hxg3glxj26fh9xnv184sfdc2wi4cnzvn7chz47wcqdsd0d5fn8w";
  };

  nativeBuildInputs = [ autoreconfHook makeWrapper asciidoc perlPackages.PodPerldoc xmlto sourceHighlight docbook_xsl docbook_xml_dtd_45 ];

  buildInputs = [ perl perlPackages.StringEscape perlPackages.DataHexdumper libdvdcss libdvdread ];

  patches = [ ./nrgtool_fix_my.patch ./removed_dvdcss_interface_2.patch];

  postFixup = ''
    for cmd in raw96cdconv nrgtool; do
      wrapProgram "$out/bin/$cmd" --prefix PERL5LIB : "$PERL5LIB"
    done
  '';

  outputs = [ "out" "doc" ];

  installTargets = [ "install" "install-doc" ];

  meta = with lib; {
    homepage = "https://repo.or.cz/cdimgtools.git/blob_plain/refs/heads/release:/README.html";
    description = "Tools to inspect and manipulate CD/DVD optical disc images";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hhm ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
