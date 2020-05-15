{ stdenv, lib, unzip, utillinux,
  libusb1, evdi, systemd, makeWrapper, requireFile, substituteAll }:

let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
    else if stdenv.hostPlatform.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";
  bins = "${arch}-ubuntu-1604";
  libPath = lib.makeLibraryPath [ stdenv.cc.cc utillinux libusb1 evdi ];

in stdenv.mkDerivation rec {
  pname = "displaylink";
  version = "5.2.14";

  src = requireFile rec {
    name = "displaylink.zip";
    sha256 = "03b176y95f04rg3lcnjps9llsjbvd8yksh1fpvjwaciz48mnxh2i";
    message = ''
      In order to install the DisplayLink drivers, you must first
      comply with DisplayLink's EULA and download the binaries and
      sources from here:

      http://www.displaylink.com/downloads/file?id=1369

      Once you have downloaded the file, please use the following
      commands and re-run the installation:

      mv \$PWD/"DisplayLink USB Graphics Software for Ubuntu ${lib.versions.majorMinor version}.zip" \$PWD/${name}
      nix-prefetch-url file://\$PWD/${name}
    '';
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    unzip $src
    chmod +x displaylink-driver-${version}.run
    ./displaylink-driver-${version}.run --target . --noexec --nodiskspace
  '';

  patches = [ (substituteAll {
    src = ./udev-installer.patch;
    inherit systemd;
  })];

  installPhase = ''
    sed -i "s,/opt/displaylink/udev.sh,$out/lib/udev/displaylink.sh,g" udev-installer.sh
    ( source udev-installer.sh
      mkdir -p $out/lib/udev/rules.d
      main systemd "$out/lib/udev/rules.d/99-displaylink.rules" "$out/lib/udev/displaylink.sh"
    )

    install -Dt $out/lib/displaylink *.spkg
    install -Dm755 ${bins}/DisplayLinkManager $out/bin/DisplayLinkManager
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${libPath} \
      $out/bin/DisplayLinkManager
    wrapProgram $out/bin/DisplayLinkManager \
      --run "cd $out/lib/displaylink"
  '';

  dontStrip = true;
  dontPatchELF = true;


  meta = with stdenv.lib; {
    description = "DisplayLink DL-5xxx, DL-41xx and DL-3x00 Driver for Linux";
    maintainers = with maintainers; [ nshalman abbradar peterhoeg ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.unfree;
    homepage = "https://www.displaylink.com/";
  };
}
