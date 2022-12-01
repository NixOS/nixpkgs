{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, libtsm
, systemd
, libxkbcommon
, libdrm
, libGLU
, libGL
, pango
, pixman
, pkg-config
, docbook_xsl
, libxslt
, mesa
, ninja
}:

stdenv.mkDerivation rec {
  pname = "kmscon";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "kmscon";
    rev = "v${version}";
    sha256 = "sha256-8owyyzCrZVbWXcCR+RA+m0MOrdzW+efI+rIMWEVEZ1o=";
  };

  buildInputs = [
    libGLU
    libGL
    libdrm
    libtsm
    libxkbcommon
    libxslt
    pango
    pixman
    systemd
    mesa
  ];

  nativeBuildInputs = [
    meson
    ninja
    docbook_xsl
    pkg-config
  ];

  patches = [
    (fetchpatch {
      name = "0001-tests-fix-warnings.patch";
      url = "https://github.com/Aetf/kmscon/commit/b65f4269b03de580923ab390bde795e7956b633f.patch";
      sha256 = "sha256-ngflPwmNMM/2JzhV+hHiH3efQyoSULfqEywzWox9iAQ=";
    })
  ];

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-O"
    + " -Wno-error=maybe-uninitialized"; # https://github.com/Aetf/kmscon/issues/49

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
