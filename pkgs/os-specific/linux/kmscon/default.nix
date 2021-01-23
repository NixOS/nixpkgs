{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, libtsm
, systemd
, libxkbcommon
, libdrm
, libGLU, libGL
, pango
, pixman
, pkg-config
, docbook_xsl
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "kmscon";
  version = "unstable-2018-09-07";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "kmscon";
    rev = "01dd0a231e2125a40ceba5f59fd945ff29bf2cdc";
    sha256 = "0q62kjsvy2iwy8adfiygx2bfwlh83rphgxbis95ycspqidg9py87";
  };

  buildInputs = [
    libGLU libGL
    libdrm
    libtsm
    libxkbcommon
    libxslt
    pango
    pixman
    systemd
  ];

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    pkg-config
  ];

  configureFlags = [
    "--enable-multi-seat"
    "--disable-debug"
    "--enable-optimizations"
    "--with-renderers=bbulk,gltex,pixman"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "KMS/DRM based System Console";
    homepage = "http://www.freedesktop.org/wiki/Software/kmscon/";
    license = licenses.mit;
    maintainers = with maintainers; [ omasanori ];
    platforms = platforms.linux;
  };
}
