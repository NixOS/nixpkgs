{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, cli11
, openssl
, zeromq
, cppzmq
, tbb_2021_8
, spdlog
, libsodium
, fmt
, vips
, nlohmann_json
, libsixel
, microsoft-gsl
, chafa
, libuuid
, libossp_uuid
, withOpencv ? stdenv.isLinux
, opencv
, withX11 ? stdenv.isLinux
, xorg
, withoutStdRanges ? stdenv.isDarwin
, range-v3
}:

stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    rev = "v${version}";
    hash = "sha256-WnrKwbh7m84xlKMuixkB8LLw8Pzb8+mZV9cHWiI6cBY=";
  };

  # error: no member named 'ranges' in namespace 'std'
  postPatch = lib.optionalString withoutStdRanges ''
    for f in src/canvas/chafa.cpp src/canvas/iterm2/iterm2.cpp; do
      sed -i "1i #include <range/v3/algorithm/for_each.hpp>" $f
      substituteInPlace $f \
        --replace "#include <ranges>" "" \
        --replace "std::ranges" "ranges"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    cli11
  ];

  buildInputs = [
    openssl
    zeromq
    cppzmq
    tbb_2021_8
    spdlog
    libsodium
    fmt
    vips
    nlohmann_json
    libsixel
    microsoft-gsl
    chafa
    (if stdenv.isLinux then libuuid else libossp_uuid)
  ] ++ lib.optionals withOpencv [
    opencv
  ] ++ lib.optionals withX11 [
    xorg.libX11
    xorg.xcbutilimage
  ] ++ lib.optionals withoutStdRanges [
    range-v3
  ];

  cmakeFlags = lib.optionals (!withOpencv) [
    "-DENABLE_OPENCV=OFF"
  ] ++ lib.optionals (!withX11) [
    "-DENABLE_X11=OFF"
  ];

  # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.14 or newer
  preBuild = lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0") ''
    export MACOSX_DEPLOYMENT_TARGET=10.14
  '';

  meta = with lib; {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    license = licenses.gpl3Plus;
    mainProgram = "ueberzug";
    maintainers = with maintainers; [ aleksana wegank ];
    platforms = platforms.unix;
  };
}
