{ stdenv
, alsa-lib
, addOpenGLRunpath
, autoPatchelfHook
, cairo
, fetchurl
, flac
, gcc11
, gnome
, gssdp
, lame
, lib
, libgmpris
, llvmPackages_10
, mpg123
, rpmextract
, wavpack

, gupnp
, gupnp-av
, meson
, ninja
}:
stdenv.mkDerivation rec {
  pname = "hqplayerd";
  version = "4.30.3-87";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/${pname}/fc35/${pname}-${version}.fc35.x86_64.rpm";
    hash = "sha256-fEze4aScWDwHDTXU0GatdopQf6FWcywWCGhR/7zXK7A=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ addOpenGLRunpath autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    cairo
    flac
    gcc11.cc.lib
    gnome.rygel
    gssdp
    gupnp
    gupnp-av
    lame
    libgmpris
    llvmPackages_10.openmp
    mpg123
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p $out/bin
    cp ./usr/bin/hqplayerd $out/bin

    # main configuration
    mkdir -p $out/etc/hqplayer
    cp ./etc/hqplayer/hqplayerd.xml $out/etc/hqplayer/

    # udev rules
    mkdir -p $out/etc/udev/rules.d
    cp ./etc/udev/rules.d/50-taudio2.rules $out/etc/udev/rules.d/

    # kernel module cfgs
    mkdir -p $out/etc/modules-load.d
    cp ./etc/modules-load.d/taudio2.conf $out/etc/modules-load.d/

    # systemd service file
    mkdir -p $out/lib/systemd/system
    cp ./usr/lib/systemd/system/hqplayerd.service $out/lib/systemd/system/

    # documentation
    mkdir -p $out/share/doc/hqplayerd
    cp ./usr/share/doc/hqplayerd/* $out/share/doc/hqplayerd/

    # misc service support files
    mkdir -p $out/var/lib/hqplayer
    cp -r ./var/lib/hqplayer/web $out/var/lib/hqplayer

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/hqplayerd.service \
      --replace /usr/bin/hqplayerd $out/bin/hqplayerd \
      --replace "NetworkManager-wait-online.service" ""
  '';

  # NB: addOpenGLRunpath needs to run _after_ autoPatchelfHook, which runs in
  # postFixup, so we tack it on here.
  doInstallCheck = true;
  installCheckPhase = ''
    addOpenGLRunpath $out/bin/hqplayerd
    $out/bin/hqplayerd --version
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software embedded HD-audio player";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
