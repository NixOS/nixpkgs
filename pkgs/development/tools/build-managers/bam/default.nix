{ stdenv, fetchurl, lua5, python }:

stdenv.mkDerivation rec {
  name = "bam-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "http://github.com/downloads/matricks/bam/${name}.tar.bz2";
    sha256 = "0z90wvyd4nfl7mybdrv9dsd4caaikc6fxw801b72gqi1m9q0c0sn";
  };

  buildInputs = [ lua5 python ];

  buildPhase = ''${stdenv.shell} make_unix.sh'';

  checkPhase = ''${python.interpreter} scripts/test.py'';

  installPhase = ''
    mkdir -p "$out/share/bam"
    cp -r docs examples tests  "$out/share/bam"
    mkdir -p "$out/bin"
    cp bam "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Yet another build manager";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.free;
    downloadPage = "http://matricks.github.com/bam/";
  };
}
