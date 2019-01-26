{ stdenv, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "geekbench-${version}";
  version = "4.2.3";

  src = fetchurl {
    url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
    sha256 = "1v42hr4p9nj7jvcjkffif6w7icns5iq0mgk9ih2mi5j2h1ngh1f7";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r geekbench.plar geekbench4 geekbench_x86_64 $out/bin

    for f in geekbench4 geekbench_x86_64 ; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/$f
      wrapProgram $out/bin/$f --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Cross-platform benchmark";
    homepage = https://geekbench.com/;
    license = licenses.unfree;
    maintainers = [ maintainers.michalrus ];
    platforms = [ "x86_64-linux" ];
  };
}
