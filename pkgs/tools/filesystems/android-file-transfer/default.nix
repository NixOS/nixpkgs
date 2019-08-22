{ stdenv, mkDerivation, fetchFromGitHub, cmake, fuse, readline, pkgconfig, osxfuse, qt5, qtbase }:

mkDerivation rec {
  pname = "android-file-transfer";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "whoozle";
    repo = "android-file-transfer-linux";
    rev = "v${version}";
    sha256 = "1pwayyd5xrmngfrmv2vwr8ns2wi199xkxf7dks8fl9zmlpizg3c3";
  };

  nativeBuildInputs = [ cmake readline pkgconfig ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ qt5.wrapQtAppsHook ]
  ;
  buildInputs = [ qtbase ]
    ++ stdenv.lib.optionals stdenv.isLinux [ fuse ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ osxfuse ]
  ;

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i"" -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/android-file-transfer.app $out/Applications

    # Fixes "This application failed to start because it could not find or load the Qt
    # platform plugin "cocoa"."
    wrapQtApp $out/Applications/android-file-transfer.app/Contents/MacOS/android-file-transfer
  '';

  meta = with stdenv.lib; {
    description = "Reliable MTP client with minimalistic UI";
    homepage = https://whoozle.github.io/android-file-transfer-linux/;
    license = licenses.lgpl21;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.unix;
  };
}
