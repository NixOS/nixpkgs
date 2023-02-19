{ lib
, haskellPackages
, fetchurl
, makeWrapper
, librsvg
, imagemagick
}:

haskellPackages.mkDerivation  rec {
  pname = "mediawiki2latex";
  version = "7.45";

  src = fetchurl {
    url = "mirror://sourceforge/wb2pdf/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Z0ZiEofPdNA/S5ssMS/HZYXJTAaDZvzvZ1+wA/tuHgU=";
  };

  executableHaskellDepends = with haskellPackages; [
    HTTP
    cereal
    directory-tree
    file-embed
    happstack-server
    http-client
    http-conduit
    http-types
    hxt
    hxt-http
    network
    network-uri
    strict
    tagsoup
    temporary
    url
    utf8-string
    utility-ht
    word8
    zip-archive
  ];
  isExecutable = true;
  buildTools = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/mediawiki2latex \
      --prefix PATH : ${librsvg}/bin \
      --prefix PATH : ${imagemagick}/bin
  '';

  homepage = "https://mediawiki2latex.wmflabs.org/";
  description = "converts MediaWiki markup to LaTeX and generates a PDF.";
  license = lib.licenses.gpl2Plus;
  maintainers = with lib.maintainers; [ doronbehar ];
}
