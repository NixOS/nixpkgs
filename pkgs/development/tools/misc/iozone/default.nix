{ stdenv, lib, fetchurl, gnuplot }:

let
  target = if stdenv.hostPlatform.system == "i686-linux" then
    "linux"
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    "linux-AMD64"
  else if stdenv.hostPlatform.system == "x86_64-darwin" then
    "macosx"
  else if stdenv.hostPlatform.system == "aarch64-linux" then
    "linux-arm"
  else throw "Platform ${stdenv.hostPlatform.system} not yet supported.";
in

stdenv.mkDerivation rec {
  pname = "iozone";
  version = "3.506";

  src = fetchurl {
    url = "http://www.iozone.org/src/current/iozone${lib.replaceStrings ["."] ["_"] version}.tar";
    hash = "sha256-EUzlwHGHO5ose6bnPQXV735mVkOSrL/NwLMmHbEPy+c=";
  };

  license = fetchurl {
    url = "http://www.iozone.org/docs/Iozone_License.txt";
    hash = "sha256-O/8yztxKBI/UKs6vwv9mq16Rn3cf/UHpSxdVnAPVCYw=";
  };

  preBuild = "pushd src/current";
  postBuild = "popd";

  buildFlags = target;

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/{bin,share/doc,libexec,share/man/man1}
    install docs/iozone.1 $out/share/man/man1/
    install docs/Iozone_ps.gz $out/share/doc/
    install -s src/current/{iozone,fileop,pit_server} $out/bin/
    install src/current/{gnu3d.dem,Generate_Graphs,gengnuplot.sh} $out/libexec/
    ln -s $out/libexec/Generate_Graphs $out/bin/iozone_generate_graphs
    # License copy is mandated by the license, but it's not in the tarball.
    install ${license} $out/share/doc/Iozone_License.txt
  '';

  preFixup = ''
    sed -i "1i#! $shell" $out/libexec/Generate_Graphs
    substituteInPlace $out/libexec/Generate_Graphs \
      --replace ./gengnuplot.sh $out/libexec/gengnuplot.sh \
      --replace 'gnuplot ' "${gnuplot}/bin/gnuplot " \
      --replace gnu3d.dem $out/libexec/gnu3d.dem
  '';

  meta = {
    description = "IOzone Filesystem Benchmark";
    homepage    = "http://www.iozone.org/";
    license     = lib.licenses.unfreeRedistributable;
    platforms   = ["i686-linux" "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    maintainers = with lib.maintainers; [ Baughn makefu ];
  };
}
