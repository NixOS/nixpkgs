{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "geekbench-${version}";
  version = "4.1.1";

  src = fetchurl {
    url = "http://cdn.primatelabs.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "1n9jyzf0a0w37hb30ip76hz73bvim76jd2fgd6131hh0shp1s4v6";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r dist/Geekbench-${version}-Linux/. $out/bin
    rm $out/bin/geekbench_x86_32

    for f in geekbench4 geekbench_x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/$f
      wrapProgram $out/bin/$f --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform benchmark";
    homepage = http://geekbench.com/;
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
