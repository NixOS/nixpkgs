{ lib
, stdenv
, fetchurl
, alsa-lib
, fltk13
, gtk2
, gtk3
, pkg-config
, python3
}:

stdenv.mkDerivation (self: {
  pname = "alsa-tools";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://alsa/tools/alsa-tools-${self.version}.tar.bz2";
    hash = "sha256-NacQJ6AfTX3kci4iNSDpQN5os8VwtsZxaRVnrij5iT4=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    alsa-lib
    fltk13
    gtk2
    gtk3
  ];

  env.TOOLSET = lib.concatStringsSep " " [
    "as10k1"
    "echomixer"
    "envy24control"
    "hda-verb"
    "hdajackretask"
    "hdajacksensetest"
    "hdspconf"
    "hdsploader"
    "hdspmixer"
    "hwmixvolume"
    "ld10k1"
    # "qlo10k1" # needs Qt
    "mixartloader"
    "pcxhrloader"
    "rmedigicontrol"
    "sb16_csp"
    # "seq" # mysterious configure error
    "sscape_ctl"
    "us428control"
    # "usx2yloader" # tries to create /etc/hptplug/usb
    "vxloader"
  ];

  postPatch = ''
    patchShebangs hwmixvolume/
  '';

  configurePhase = ''
    runHook preConfigure

    for tool in $TOOLSET; do
      echo "Configuring $tool:"
      pushd "$tool"
      ./configure --prefix="$out"
      popd
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building $tool:"
    for tool in $TOOLSET; do
      pushd "$tool"
      make
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    echo "Installing $tool:"
    for tool in $TOOLSET; do
      pushd "$tool"
      make install
      popd
    done

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA Tools";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
