{ fetchzip
, libX11
, libGLU, libGL
, makeWrapper
, lib, stdenv
}:

let

  libPath = lib.makeLibraryPath [
    libGLU libGL
    stdenv.cc.cc
    libX11
  ];

  inidir = "\\\${XDG_CONFIG_HOME:-\\$HOME/.config}/kisslicer";

in

stdenv.mkDerivation rec {
  pname = "kisslicer";
  version = "1.6.3";

  src = fetchzip {
    url = "https://www.kisslicer.com/uploads/1/5/3/8/15381852/kisslicer_linux64_${version}_release.zip";
    sha256 = "1xmywj5jrcsqv1d5x3mphhvafs4mfm9l12npkhk7l03qxbwg9j82";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libGLU libGL
    libX11
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p * $out/bin
  '';

  fixupPhase = ''
    chmod 755 $out/bin/KISSlicer
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}   $out/bin/KISSlicer
    wrapProgram $out/bin/KISSlicer \
      --add-flags "-inidir ${inidir}" \
      --run "mkdir -p ${inidir}"
  '';

  meta = with lib; {
    description = "Convert STL files into Gcode";
    homepage = "http://www.kisslicer.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.cransom ];
    platforms = [ "x86_64-linux" ];
  };
}
