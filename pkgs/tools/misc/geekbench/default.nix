{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "geekbench";
  version = "5.2.0";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "1rvzll57igivhlxp058mhmcbq07q2zr52xbi1wyn85qr9ihrhx08";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r geekbench.plar geekbench5 geekbench_x86_64 $out/bin

    for f in geekbench5 geekbench_x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/$f
      wrapProgram $out/bin/$f --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
