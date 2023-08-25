{ stdenv
, lib
, unzip
, util-linux
, libusb1
, evdi
, systemd
, makeWrapper
, requireFile
, substituteAll
}:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
    else if stdenv.hostPlatform.system == "i686-linux" then "x86"
    else throw "Unsupported architecture";
  bins = "${arch}-ubuntu-1604";
  libPath = lib.makeLibraryPath [ stdenv.cc.cc util-linux libusb1 evdi ];

in
stdenv.mkDerivation rec {
  pname = "displaylink";
  version = "5.7.0-61.129";

  src = requireFile rec {
    name = "displaylink-570.zip";
    sha256 = "807f1c203ac1e71c6f1f826493b9bb32e277f07cb2cf48537bf8cfdc68dd1515";
    message = ''
      In order to install the DisplayLink drivers, you must first
      comply with DisplayLink's EULA and download the binaries and
      sources from here:

      https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu-5.7

      Once you have downloaded the file, please use the following
      commands and re-run the installation:

      mv \$PWD/"DisplayLink USB Graphics Software for Ubuntu5.7-EXE.zip" \$PWD/${name}
      nix-prefetch-url file://\$PWD/${name}
    '';
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    unzip $src
    chmod +x displaylink-driver-${version}.run
    ./displaylink-driver-${version}.run --target . --noexec --nodiskspace
  '';

  installPhase = ''
    install -Dt $out/lib/displaylink *.spkg
    install -Dm755 ${bins}/DisplayLinkManager $out/bin/DisplayLinkManager
    mkdir -p $out/lib/udev/rules.d $out/share
    cp ${./99-displaylink.rules} $out/lib/udev/rules.d/99-displaylink.rules
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath ${libPath} \
      $out/bin/DisplayLinkManager
    wrapProgram $out/bin/DisplayLinkManager \
      --chdir "$out/lib/displaylink"

    # We introduce a dependency on the source file so that it need not be redownloaded everytime
    echo $src >> "$out/share/workspace_dependencies.pin"
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "DisplayLink DL-5xxx, DL-41xx and DL-3x00 Driver for Linux";
    homepage = "https://www.displaylink.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    hydraPlatforms = [];
  };
}
