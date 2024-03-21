{ lib, stdenv, fetchFromGitHub, cmake, qtbase }:

# WARNING: Supported only for use with glibc version 2.27 or older.
# In order to use it with newer glibc you can use the following flags:
# -unsupported-allow-new-glibc and -unsupported-bundle-everything
# https://github.com/probonopd/linuxdeployqt/issues/340
stdenv.mkDerivation rec {
  pname = "linuxdeployqt";
  version = "20220821";
  commit = "5fa79fa1df0788b45ed04963d7478d4e68fda2f8c";
  name = "${pname}-${version}-${lib.substring 0 8 commit}";

  src = fetchFromGitHub {
    owner = "probonopd";
    repo = "linuxdeployqt";
    rev = commit;
    sha256 = "sha256-HNReONrdDnJf+s48m/vxmrkuba+1KmRwYTjtj+QKioo=";
  };

  cmakeFlags = [
    "-DGIT_COMMIT=${commit}"
    "-DGIT_TAG_NAME=${version}"
  ];

  TRAVIS_BUILD_NUMBER = version;

  dontWrapQtApps = true;

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp tools/linuxdeployqt/linuxdeployqt $out/bin
  '';

  meta = with lib; {
    description = "Tool for bundling QT AppImages";
    longDescription = ''
      Makes Linux applications self-contained by copying in the libraries and
      plugins that the application uses, and optionally generates an AppImage.
      Can be used for Qt and other applications.
    '';
    homepage = "https://github.com/probonopd/linuxdeployqt";
    license = with licenses; [ gpl3 lgpl3 ];
    maintainers = with maintainers; [ jakubgs ];
    platforms = platforms.all;
  };
}
