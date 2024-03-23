{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoPatchelfHook
, makeWrapper
, buildNpmPackage
, cmake
, avahi
, libevdev
, libpulseaudio
, xorg
, libxcb
, openssl
, libopus
, boost
, pkg-config
, libdrm
, wayland
, libffi
, libcap
, mesa
, curl
, pcre
, pcre2
, libuuid
, libselinux
, libsepol
, libthai
, libdatrie
, libxkbcommon
, libepoxy
, libva
, libvdpau
, libglvnd
, numactl
, amf-headers
, intel-media-sdk
, svt-av1
, vulkan-loader
, libappindicator
, libnotify
, miniupnpc
, config
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }
}:
let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
stdenv'.mkDerivation rec {
  pname = "sunshine";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    rev = "v${version}";
    sha256 = "sha256-O9U4zP1o6yWtzk+2DW7ueimvsTuajLY8IETlvCT4jTE=";
    fetchSubmodules = true;
  };

  patches = [
    # remove npm install as it needs internet access -- handled separately below
    ./dont-build-webui.patch
    # revert https://github.com/LizardByte/Sunshine/pull/2046 - let cmake install handle udev and systemd files
    (fetchpatch {
      url = "https://github.com/LizardByte/Sunshine/commit/0d4dfcd708c0027b7d8827a03163858800fa79fa.patch";
      hash = "sha256-77NtfX0zB7ty92AyFOz9wJoa1jHshlNbPQ7NOpqUuYo=";
      revert = true;
    })
  ];

  # build webui
  ui = buildNpmPackage {
    inherit src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-jAZUu2CfcqhC2xMiZYpY7KPCRVFQgT/kgUvSI+5Cpkc=";

    # use generated package-lock.json as upstream does not provide one
    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
    makeWrapper
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddDriverRunpath
  ];

  buildInputs = [
    avahi
    libevdev
    libpulseaudio
    xorg.libX11
    libxcb
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
    xorg.libXi
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
    pcre
    pcre2
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    libxkbcommon
    libepoxy
    libva
    libvdpau
    numactl
    mesa
    amf-headers
    svt-av1
    libappindicator
    libnotify
    miniupnpc
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ] ++ lib.optionals stdenv.isx86_64 [
    intel-media-sdk
  ];

  runtimeDependencies = [
    avahi
    mesa
    xorg.libXrandr
    libxcb
    libglvnd
  ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  postPatch = ''
    # fix hardcoded libevdev path
    substituteInPlace cmake/compile_definitions/linux.cmake \
      --replace '/usr/include/libevdev-1.0' '${libevdev}/include/libevdev-1.0'

    substituteInPlace packaging/linux/sunshine.desktop \
      --replace '@PROJECT_NAME@' 'Sunshine' \
      --replace '@PROJECT_DESCRIPTION@' 'Self-hosted game stream host for Moonlight' \
      --replace '/usr/bin/env systemctl start --u sunshine' 'sunshine'
  '';

  preBuild = ''
    # copy webui where it can be picked up by build
    cp -r ${ui}/build ../
  '';

  # allow Sunshine to find libvulkan
  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  postInstall = ''
    install -Dm644 ../packaging/linux/${pname}.desktop $out/share/applications/${pname}.desktop
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Sunshine is a Game stream host for Moonlight";
    homepage = "https://github.com/LizardByte/Sunshine";
    license = licenses.gpl3Only;
    mainProgram = "sunshine";
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}
