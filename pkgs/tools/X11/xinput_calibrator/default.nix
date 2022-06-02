{ lib, stdenv, fetchFromGitHub, libXi, xorgproto, autoconf, automake, libtool, m4, xlibsWrapper, pkg-config }:

stdenv.mkDerivation rec {
  pname = "xinput_calibrator";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "tias";
    repo = "xinput_calibrator";
    rev = "v${version}";
    sha256 = "5ZkNw+CKNUcPt1PY5PLzB/OT2wcf5n3UcaQlmMcwRVE=";
  };

  preConfigure = "./autogen.sh --with-gui=X11";

  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ xorgproto libXi libtool m4 xlibsWrapper ];

  meta = {
    homepage = "https://github.com/tias/xinput_calibrator";
    description = "A generic touchscreen calibration program for X.Org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.flosse ];
    platforms = lib.platforms.linux;
  };
}
