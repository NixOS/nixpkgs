{ lib, stdenv, fetchurl, buildEnv, makeWrapper, glib, alsa-lib , dbus, gtk2, atk
, pango, freetype, fontconfig, gdk-pixbuf , cairo, cups, expat, nspr, gconf, nss
, xorg, libcap, unzip
}:

let
  thrustEnv = buildEnv {
    name = "env-thrust";
    paths = [
      stdenv.cc.cc glib dbus gtk2 atk pango freetype fontconfig gdk-pixbuf
      cairo cups expat alsa-lib nspr gconf nss xorg.libXrender xorg.libX11
      xorg.libXext xorg.libXdamage xorg.libXtst xorg.libXcomposite
      xorg.libXi xorg.libXfixes xorg.libXrandr xorg.libXcursor libcap
    ];
  };
in stdenv.mkDerivation rec {
  pname = "thrust";
  version = "0.7.6";

  src = fetchurl {
    url = "https://github.com/breach/thrust/releases/download/v${version}/thrust-v${version}-linux-x64.zip";
    sha256 = "07rrnlj0gk500pvar4b1wdqm05p4n9yjwn911x93bd2qwc8r5ymc";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ thrustEnv ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/thrust
    unzip -d $out/libexec/thrust/ $src
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/libexec/thrust/thrust_shell
    wrapProgram $out/libexec/thrust/thrust_shell \
      --prefix "LD_LIBRARY_PATH" : "${thrustEnv}/lib:${thrustEnv}/lib64"
    ln -s $out/libexec/thrust/thrust_shell $out/bin
  '';

  meta = with lib; {
    description = "Chromium-based cross-platform / cross-language application framework";
    homepage = "https://github.com/breach/thrust";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = [ maintainers.osener ];
    platforms = [ "x86_64-linux" ];
  };
}
