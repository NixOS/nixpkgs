{ stdenv
, alsa-lib
, autoPatchelfHook
, cairo
, fetchurl
, flac
, gcc11
, gnome
, gssdp
, gupnp
, lib
, libgmpris
, llvmPackages_10
, rpmextract
, wavpack
}:

stdenv.mkDerivation rec {
  pname = "hqplayerd";
  version = "4.24.2-63";

  src = fetchurl {
    url = "https://www.signalyst.eu/bins/${pname}/fc34/${pname}-${version}.fc34.x86_64.rpm";
    sha256 = "sha256-6JUgHDO+S73n/IVQhkmC0Nw4GQVzTLtiBbz/wZiflRg=";
  };

  unpackPhase = ''
    ${rpmextract}/bin/rpmextract $src
  '';

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];

  buildInputs = [
    alsa-lib
    cairo
    flac
    gcc11.cc.lib
    gnome.rygel
    gssdp
    gupnp
    libgmpris
    llvmPackages_10.openmp
    wavpack
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main executable
    mkdir -p $out/bin
    cp ./usr/bin/hqplayerd $out/bin

    # udev rules
    mkdir -p $out/etc/udev/rules.d
    cp ./etc/udev/rules.d/50-taudio2.rules $out/etc/udev/rules.d

    # kernel module cfgs
    mkdir -p $out/etc/modules-load.d
    cp ./etc/modules-load.d/taudio2.conf $out/etc/modules-load.d

    # systemd service file
    mkdir -p $out/lib/systemd/system
    cp ./usr/lib/systemd/system/hqplayerd.service $out/lib/systemd/system

    # documentation
    mkdir -p $out/share/doc/hqplayerd
    cp ./usr/share/doc/hqplayerd/* $out/share/doc/hqplayerd

    # misc service support files
    mkdir -p $out/var/lib/hqplayerd
    cp -r ./var/lib/hqplayer/web $out/var/lib/hqplayer

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/hqplayerd.service \
      --replace /usr/bin/hqplayerd $out/bin/hqplayerd
  '';

  postFixup = ''
    patchelf --replace-needed libomp.so.5 libomp.so $out/bin/hqplayerd
  '';

  meta = with lib; {
    homepage = "https://www.signalyst.com/custom.html";
    description = "High-end upsampling multichannel software embedded HD-audio player";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
