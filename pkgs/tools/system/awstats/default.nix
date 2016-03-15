{ stdenv, fetchurl, perlPackages, jdk }:

perlPackages.buildPerlPackage rec {
  name = "awstats-${version}";
  version = "7.4";

  src = fetchurl {
    url = "mirror://sourceforge/awstats/${name}.tar.gz";
    sha256 = "0mdbilsl8g9a84qgyws4pakhqr3mfhs5g5dqbgsn9gn285rzxas3";
  };

  postPatch = ''
    substituteInPlace wwwroot/cgi-bin/awstats.pl \
      --replace /usr/share/awstats/ "$out/wwwroot/cgi-bin/"
  '';

  outputs = [ "out" "bin" "doc" ];

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

    mkdir -p "$bin/bin"
    ln -s "$out/wwwroot/cgi-bin/awstats.pl" "$bin/bin/awstats"

    mkdir -p "$doc/share/"
    mv README.md docs/
    mv docs "$doc/share/awstats"
  '';

  meta = with stdenv.lib; {
    description = "Real-time logfile analyzer to get advanced statistics";
    homepage = http://awstats.org;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

