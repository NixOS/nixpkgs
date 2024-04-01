{ lib
, stdenv
, fetchFromGitHub
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
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    rev = "v${version}";
    sha256 = "sha256-So8fX0XQoW2cdTWWENoE07EU6e8vvjeTpizLoaDTjeg=";
    fetchSubmodules = true;
  };

  patches = [
    # remove npm install as it needs internet access -- handled separately below
    ./dont-build-webui.patch
  ];

  # build webui
  ui = buildNpmPackage {
    inherit src version;
    pname = "sunshine-ui";
    npmDepsHash = "sha256-0487ntbJZ20MZHezQ+Z3EJkidF3Dgoh/mynYwR7k/+I=";

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
    # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
  ];

  postPatch = ''
    # remove upstream dependency on systemd and udev
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    substituteInPlace packaging/linux/sunshine.desktop \
      --subst-var-by PROJECT_NAME 'Sunshine' \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --replace-fail '/usr/bin/env systemctl start --u sunshine' 'sunshine'

    substituteInPlace packaging/linux/sunshine.service.in \
      --subst-var-by PROJECT_DESCRIPTION 'Self-hosted game stream host for Moonlight' \
      --subst-var-by SUNSHINE_EXECUTABLE_PATH $out/bin/sunshine
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
