{ stdenv
, fetchFromGitHub
, pkgconfig
, wafHook
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, libxml2
, libxslt
, curl
, libevent
}:

stdenv.mkDerivation rec {
  pname = "saldl";
  version = "40";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "19ajci5h5gdnrvwf0l7xy5s58z2di68rrvcmqpsmpp4lfr37rk2l";
  };

  nativeBuildInputs = [
    pkgconfig
    wafHook
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
  ];

  buildInputs = [ curl libevent ];

  wafConfigureFlags = [ "--saldl-version ${version}" "--no-werror" ];

  outputs = [ "out" "man" ];

  meta = with stdenv.lib; {
    description = "CLI downloader optimized for speed and early preview";
    homepage = "https://saldl.github.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.all;
  };
}
