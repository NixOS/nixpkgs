{ stdenv, fetchurl, perlPackages, jdk }:

perlPackages.buildPerlPackage rec {
  name = "awstats-${version}";
  version = "7.7";

  src = fetchurl {
    url = "mirror://sourceforge/awstats/${name}.tar.gz";
    sha256 = "0z3p77jnpjilajs9yv87r8xla2x1gjqlvrhpbgbh5ih73386v3j2";
  };

  postPatch = ''
    substituteInPlace wwwroot/cgi-bin/awstats.pl \
      --replace /usr/share/awstats/ "$out/wwwroot/cgi-bin/"
  '';

  outputs = [ "bin" "out" "doc" ]; # bin just links the user-run executable
  propagatedBuildOutputs = [ ]; # otherwise out propagates bin -> cycle

  buildInputs = with perlPackages; [ ]; # plugins will need some

  preConfigure = ''
    touch Makefile.PL
    patchShebangs .
  '';

  # build our own JAR
  preBuild = ''
    (
      cd wwwroot/classes/src
      rm ../*.jar
      PATH="${jdk}/bin" "$(type -P perl)" Makefile.pl
      test -f ../*.jar
    )
  '';

  doCheck = false;

  installPhase = ''
    mkdir "$out"
    mv wwwroot "$out/wwwroot"
    rm -r "$out/wwwroot/classes/src/"

    mkdir -p "$out/share/awstats"
    mv tools "$out/share/awstats/tools"

    mkdir -p "$bin/bin"
    ln -s "$out/wwwroot/cgi-bin/awstats.pl" "$bin/bin/awstats"

    mkdir -p "$doc/share/doc"
    mv README.md docs/
    mv docs "$doc/share/doc/awstats"
  '';

  meta = with stdenv.lib; {
    description = "Real-time logfile analyzer to get advanced statistics";
    homepage = http://awstats.org;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

