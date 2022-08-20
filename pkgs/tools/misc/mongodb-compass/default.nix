{
alsa-lib,
at-spi2-atk,
at-spi2-core,
atk,
cairo,
cups,
curl,
dbus,
dpkg,
expat,
fetchurl,
fontconfig,
freetype,
gdk-pixbuf,
glib,
gtk3,
lib,
libdrm,
libnotify,
libsecret,
libuuid,
libxcb,
libxkbcommon,
mesa,
nspr,
nss,
pango,
stdenv,
systemd,
wrapGAppsHook,
xorg,
}:

let
  version = "1.32.6";

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libsecret
    libuuid
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxkbfile
    xorg.libxshmfence
    (lib.getLib stdenv.cc.cc)
  ];

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://downloads.mongodb.com/compass/mongodb-compass_${version}_amd64.deb";
        sha256 = "sha256-lrdDy8wtkIBQC/OPdSoKmOFIuajKeu1qtyRHOLZSSVI=";
      }
    else
      throw "MongoDB compass is not supported on ${stdenv.hostPlatform.system}";
      # NOTE While MongoDB Compass is available to darwin, I do not have resources to test it
      # Feel free to make a PR adding support if desired

in stdenv.mkDerivation {
  pname = "mongodb-compass";
  inherit version;

  inherit src;

  buildInputs = [ dpkg wrapGAppsHook gtk3 ];
  dontUnpack = true;

  buildCommand = ''
    IFS=$'\n'

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract

    mkdir -p $out
    mv usr/* $out

    # cp -av $out/usr/* $out
    rm -rf $out/share/lintian

    # The node_modules are bringing in non-linux files/dependencies
    find $out -name "*.app" -exec rm -rf {} \; || true
    find $out -name "*.dll" -delete
    find $out -name "*.exe" -delete

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in `find $out -type f -perm /0111 -o -name \*.so\*`; do
      echo "Manipulating file: $file"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/mongodb-compass "$file" || true
    done

    wrapGAppsHook $out/bin/mongodb-compass
  '';

  meta = with lib; {
    description = "The GUI for MongoDB";
    maintainers = with maintainers; [ bryanasdev000 ];
    homepage = "https://github.com/mongodb-js/compass";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.sspl;
    platforms = [ "x86_64-linux" ];
  };
}
