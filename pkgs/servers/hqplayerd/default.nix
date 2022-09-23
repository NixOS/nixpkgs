{ stdenv, lib
, addOpenGLRunpath
, alsa-lib
, autoPatchelfHook
, cairo
, fetchurl
, flac
, gcc12
, gnome
, gssdp
, gupnp
, gupnp-av
, lame
, libgmpris
, libusb-compat-0_1
, llvmPackages_10
, meson
, mpg123
, ninja
, rpmextract
, wavpack
}:
stdenv.mkDerivation rec {
  pname = "hqplayerd";
  version = "4.32.4-94sse42";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/${pname}/fc36/${pname}-${version}.fc36.x86_64.rpm";
    hash = "sha256-hTckJdZzD/Sx/uV30dlGiT46QvzIGp6BQdNNRlQ/Mgw=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ addOpenGLRunpath autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    cairo
    flac
    gcc12.cc.lib
    gnome.rygel
    gssdp
    gupnp
    gupnp-av
    lame
    libgmpris
    libusb-compat-0_1
    llvmPackages_10.openmp
    mpg123
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # executables
    mkdir -p $out
    cp -rv ./usr/bin $out/bin

    # libs
    mkdir -p $out
    cp -rv ./opt/hqplayerd/lib $out

    # configuration
    mkdir -p $out/etc
    cp -rv ./etc/hqplayer $out/etc/

    # udev rules
    mkdir -p $out/etc/udev
    cp -rv ./etc/udev/rules.d $out/etc/udev/

    # kernel module cfgs
    mkdir -p $out/etc
    cp -rv ./etc/modules-load.d $out/etc/

    # systemd service file
    mkdir -p $out/lib/systemd
    cp -rv ./usr/lib/systemd/system $out/lib/systemd/

    # documentation
    mkdir -p $out/share/doc
    cp -rv ./usr/share/doc/hqplayerd $out/share/doc/

    # misc service support files
    mkdir -p $out/var/lib
    cp -rv ./var/lib/hqplayer $out/var/lib/
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
