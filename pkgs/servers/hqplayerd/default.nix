{ stdenv, lib
, addOpenGLRunpath
, alsa-lib
, autoPatchelfHook
, cairo
, fetchurl
, flac
, gcc12
, gssdp
, gupnp
, gupnp-av
, lame
, libgmpris
, libusb-compat-0_1
, llvmPackages_14
, mpg123
, rpmextract
, wavpack

, callPackage
, rygel ? null
}@inputs:
let
  # FIXME: Replace with gnome.rygel once hqplayerd releases a new version.
  rygel-hqplayerd = inputs.rygel or (callPackage ./rygel.nix { });
in
stdenv.mkDerivation rec {
  pname = "hqplayerd";
  version = "5.2.0-6";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/${pname}/fc37/${pname}-${version}.fc37.x86_64.rpm";
    hash = "sha256-AJKSj7t1yog3EXrzdods9Jk35ibEbegnXQzFcsr2N7I=";
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
    rygel-hqplayerd
    gssdp
    gupnp
    gupnp-av
    lame
    libgmpris
    libusb-compat-0_1
    llvmPackages_14.openmp
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

  passthru = {
    rygel = rygel-hqplayerd;
  };

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software embedded HD-audio player";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
