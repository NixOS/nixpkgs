{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, buildNpmPackage
, cmake
, avahi
, libevdev
, libpulseaudio
, xorg
, libxcb
, openssl
, libopus
, ffmpeg-full
, boost
, pkg-config
, libdrm
, wayland
, libffi
, libcap
, mesa
, curl
, libva
, libvdpau
, numactl
, cudaSupport ? false
, cudaPackages ? {}
}:

stdenv.mkDerivation rec {
  pname = "sunshine";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    rev = "v${version}";
    sha256 = "sha256-o489IPza1iLoe74Onn2grP5oeNy0ZYdrvBoMEWlbwCE=";
    fetchSubmodules = true;
  };

  # remove pre-built ffmpeg; use ffmpeg from nixpkgs
  patches = [ ./ffmpeg.diff ];

  # fetch node_modules needed for webui
  ui = buildNpmPackage {
    inherit src version;
    pname = "sunshine-ui";
    sourceRoot = "source/src_assets/common/assets/web";
    npmDepsHash = "sha256-fg/turcpPMHUs6GBwSoJl4Pxua/lGfCA1RzT1R5q53M=";

    dontNpmBuild = true;

    # use generated package-lock.json upstream does not provide one
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/
    '';
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    avahi
    ffmpeg-full
    libevdev
    libpulseaudio
    xorg.libX11
    libxcb
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
    openssl
    libopus
    boost
    libdrm
    wayland
    libffi
    libevdev
    libcap
    libdrm
    curl
    libva
    libvdpau
    numactl
    mesa
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];

  runtimeDependencies = [
    avahi
    mesa
    xorg.libXrandr
    libxcb
  ];

  CXXFLAGS = [
    "-Wno-format-security"
  ];
  CFLAGS = [
    "-Wno-format-security"
  ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  postPatch = ''
    # Don't force the need for a static boost, fix hardcoded libevdev path
    substituteInPlace CMakeLists.txt \
      --replace 'set(Boost_USE_STATIC_LIBS ON)' '# set(Boost_USE_STATIC_LIBS ON)' \
      --replace '/usr/include/libevdev-1.0' '${libevdev}/include/libevdev-1.0'
  '';

  preBuild = ''
    # copy node_modules where they can be picked up by build
    mkdir -p ../src_assets/common/assets/web/node_modules
    cp -r ${ui}/node_modules/* ../src_assets/common/assets/web/node_modules
  '';

  meta = with lib; {
    description = "Sunshine is a Game stream host for Moonlight.";
    homepage = "https://github.com/LizardByte/Sunshine";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}
