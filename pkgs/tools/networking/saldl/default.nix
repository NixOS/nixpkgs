{ lib, stdenv
, fetchFromGitHub
, pkg-config
, wafHook
, python3
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, libxml2
, libxslt
, curl
, libevent
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "update-waf-to-2-0-24.patch";
      url = "https://github.com/saldl/saldl/commit/360c29d6c8cee5f7e608af42237928be429c3407.patch";
      hash = "sha256-RBMnsUtd0BaZe/EXypDCK4gpUU0dgucWmOcJRn5/iTA=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    wafHook
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
