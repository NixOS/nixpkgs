{ lib, stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/containers/bubblewrap/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-Fv2vM3mdYxBONH4BM/kJGW/pDQxQUV0BC8tCLrWgCBg=";
  };

  nativeBuildInputs = [ libxslt docbook_xsl ];
  buildInputs = [ libcap ];

  meta = with lib; {
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
