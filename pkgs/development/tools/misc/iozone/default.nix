{ stdenv, fetchurl, gnuplot }:

let
  target = if stdenv.system == "i686-linux" then
    "linux"
  else if stdenv.system == "x86_64-linux" then
    "linux-AMD64"
  else if stdenv.system == "x86_64-darwin" then
    "macosx"
  else abort "Platform ${stdenv.system} not yet supported.";
in

stdenv.mkDerivation rec {
  name = "iozone-3.434";

  src = fetchurl {
    url = http://www.iozone.org/src/current/iozone3_434.tar;
    sha256 = "0aj63mlb91aivz3z71zn8nbwci1pi18qk8zc65dm19cknffqsf1c";
  };

  license = fetchurl {
    url = http://www.iozone.org/docs/Iozone_License.txt;
    sha256 = "1309sl1rqm8p9gll3z8zfygr2pmbcvzw5byf5ba8y12avk735zrv";
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
    homepage    = http://www.iozone.org/;
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = ["i686-linux" "x86_64-linux" "x86_64-darwin"];
    maintainers = [ stdenv.lib.maintainers.Baughn ];
  };
}
