{ stdenv, lib, fetchurl, fetchFromGitHub, unzip, kernel, utillinux, libdrm, libusb1, makeWrapper }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";
  libPath = lib.makeLibraryPath [ stdenv.cc.cc utillinux libusb1 ];

in stdenv.mkDerivation rec {
  name = "displaylink-${version}";
  version = "1.1.62";

  src = fetchFromGitHub {
    owner = "DisplayLink";
    repo = "evdi";
    rev = "fe779940ff9fc7b512019619e24a5b22e4070f6a";
    sha256 = "02hw83f6lscms8hssjzf30hl9zly3b28qcxwmxvnqwfhx1q491z9";
  };

  daemon = fetchurl {
    name = "displaylink.zip";
    url = "http://www.displaylink.com/downloads/file?id=607";
    sha256 = "0jky3xk4dfzbzg386qya9l9952i4m8zhf55fdl06pi9r82k2iijx";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  buildInputs = [ kernel libdrm ];

  buildCommand = ''
    unpackPhase
    cd $sourceRoot
    unzip $daemon
    chmod +x displaylink-driver-${version}.run
    ./displaylink-driver-${version}.run --target daemon --noexec

    ( cd module
      export makeFlags="$makeFlags KVER=${kernel.modDirVersion} KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      export hardeningDisable="pic format"
      buildPhase
      install -Dm755 evdi.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/drm/evdi/evdi.ko
    )

    ( cd library
      buildPhase
      install -Dm755 libevdi.so $out/lib/libevdi.so
    )

    fixupPhase

    ( cd daemon
      install -Dt $out/lib/displaylink *.spkg
      install -Dm755 ${arch}/DisplayLinkManager $out/bin/DisplayLinkManager
      patchelf \
        --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
        --set-rpath $out/lib:${libPath} \
        $out/bin/DisplayLinkManager
      wrapProgram $out/bin/DisplayLinkManager \
        --run "cd $out/lib/displaylink"
    )
  '';

  meta = with stdenv.lib; {
    description = "DisplayLink DL-5xxx, DL-41xx and DL-3x00 Driver for Linux";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.unfree;
    homepage = "http://www.displaylink.com/";
  };
}
