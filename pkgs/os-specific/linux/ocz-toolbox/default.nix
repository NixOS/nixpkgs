{ stdenv, fetchurl, libXrender, fontconfig, freetype, libXext, libX11 }:

let arch = if stdenv.system == "x86_64-linux" then "64"
           else if stdenv.system == "i686-linux" then "32"
           else abort "OCZ Toolbox only support {x86-64,i686}-linux targets";
in stdenv.mkDerivation rec {
  version = "4.9.0.634";
  name = "ocz-toolbox-${version}";

  src = fetchurl {
    url = "http://ocz.com/consumer/download/firmware/OCZToolbox_v${version}_linux.tar.gz";
    sha256 = "0h51p5bg9h2smxxy1r4xkzzjjavhgql7yy12qmjk0vbh13flgx3y";
  };

  prePatch = ''
    cd linux${arch}
  '';

  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc libXrender fontconfig freetype libXext libX11 ];

  installPhase = ''
    install -Dm755 OCZToolbox $out/bin/OCZToolbox
    patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "$libPath" \
      $out/bin/OCZToolbox
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Update firmware and BIOS, secure erase, view SMART attributes, and view drive details of your OCZ SSD";
    homepage = "http://ocz.com/consumer/download/firmware";
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
  };
}
