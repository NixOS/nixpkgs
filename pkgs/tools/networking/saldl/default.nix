{ lib, stdenv
, fetchFromGitHub
, pkg-config
, waf
, python3
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
  version = "41";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PAX2MUyBWWU8kGkaeoCJteidgszh7ipwDJbrLXzVsn0=";
  };

  nativeBuildInputs = [
    pkg-config
    waf.hook
    python3
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
  ];

  buildInputs = [ curl libevent ];

  wafConfigureFlags = [ "--saldl-version ${version}" "--no-werror" ];

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "CLI downloader optimized for speed and early preview";
    homepage = "https://saldl.github.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.all;
  };
}
