{ stdenv, fetchFromGitHub, boost, cmake, git, python2, perl, qtbase, SDL2 }:

stdenv.mkDerivation rec {
  pname = "yuzu";
  version = "unstable-2019-05-03";

  src = fetchFromGitHub {
    owner = "yuzu-emu";
    repo = "yuzu";
    fetchSubmodules = true;
    deepClone = true;  # Yuzu's CMake submodule check uses .git presence.
    branchName = "master";  # For nicer in-app version numbers.
    rev = "1f72bb733f743d55ac890c990f0fefea9a0ef290";
    sha256 = "0lvw1i3601ycc6ipnssq398hcgsaq2an91wic46ppd5qqlck50fi";
  };

  nativeBuildInputs = [ cmake git perl python2 ];
  buildInputs = [ boost qtbase SDL2 ];

  cmakeFlags = [
    # Disable as much vendoring as upstream allows. We still use vendored
    # libunicorn since the fork used by Yuzu is significantly different.
    "-DYUZU_USE_BUNDLED_QT=OFF"
    "-DYUZU_USE_BUNDLED_SDL2=OFF"
    "-DYUZU_USE_BUNDLED_UNICORN=ON"
  ];

  meta = with stdenv.lib; {
    description = "Experimental open-source emulator for the Nintendo Switch";
    homepage = "https://yuzu-emu.org";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ delroth ];
  };
}
