{ stdenv, lib, fetchurl, unzip, utillinux, libusb1, evdi, systemd, makeWrapper }:

let
  arch =
    if stdenv.system == "x86_64-linux" then "x64"
    else if stdenv.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";
  bins = "${arch}-ubuntu-1604";
  libPath = lib.makeLibraryPath [ stdenv.cc.cc utillinux libusb1 evdi ];

in stdenv.mkDerivation rec {
  name = "displaylink-${version}";
  version = "1.3.52";

  src = fetchurl {
    name = "displaylink.zip";
    url = "http://www.displaylink.com/downloads/file?id=744";
    sha256 = "0ridpsxcf761vym0nlpq702qa46ynddzci17bjmyax2pph7khr0k";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  buildCommand = ''
    unzip $src
    chmod +x displaylink-driver-${version}.run
    ./displaylink-driver-${version}.run --target . --noexec

    sed -i "s,/opt/displaylink/udev.sh,$out/lib/udev/displaylink.sh,g" udev-installer.sh
    ( source udev-installer.sh
      mkdir -p $out/lib/udev/rules.d
      main systemd "$out/lib/udev/rules.d/99-displaylink.rules" "$out/lib/udev/displaylink.sh"
    )
    sed -i '2iPATH=${systemd}/bin:$PATH' $out/lib/udev/displaylink.sh

    install -Dt $out/lib/displaylink *.spkg
    install -Dm755 ${bins}/DisplayLinkManager $out/bin/DisplayLinkManager
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${libPath} \
      $out/bin/DisplayLinkManager
    wrapProgram $out/bin/DisplayLinkManager \
      --run "cd $out/lib/displaylink"

    fixupPhase
  '';

  meta = with stdenv.lib; {
    description = "DisplayLink DL-5xxx, DL-41xx and DL-3x00 Driver for Linux";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.unfree;
    homepage = "http://www.displaylink.com/";
  };
}
