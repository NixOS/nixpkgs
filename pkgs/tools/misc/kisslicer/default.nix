{ fetchzip
, libX11
, libGLU_combined
, makeWrapper
, stdenv
}:

let

  libPath = stdenv.lib.makeLibraryPath [
    libGLU_combined
    stdenv.cc.cc
    libX11
  ];

  inidir = "\\\${XDG_CONFIG_HOME:-\\$HOME/.config}/kisslicer";

in

stdenv.mkDerivation rec {
  name = "kisslicer-1.6.2";

  src = fetchzip {
    url = "http://www.kisslicer.com/uploads/1/5/3/8/15381852/kisslicer_linux64_1.6.2_release.zip";
    sha256 = "0fb7hzic78skq3ykc37srnjsw0yri7m0pb3arlz076ws7jrcbr0f";
    stripRoot = false;
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  buildInputs = [
    makeWrapper
    libGLU_combined
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

  meta = with stdenv.lib; {
    description = "Convert STL files into Gcode";
    homepage = http://www.kisslicer.com;
    license = licenses.unfree;
    maintainers = [ maintainers.cransom ];
    platforms = [ "x86_64-linux" ];
  };
}
