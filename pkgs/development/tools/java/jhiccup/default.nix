{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "jhiccup-${version}";
  version = "2.0.8";

  src = fetchzip {
    url    = "https://www.azul.com/files/jHiccup-${version}-dist.zip";
    sha256 = "1q4wd5ywisgh0f4ic7iglxai0gc8mnl1pkjw1hm1xdij8j5i488g";
  };

  configurePhase = ":";
  buildPhase     = ":";
  installPhase = ''
    mkdir -p $out/bin $out/share/java
    cp *.jar $out/share/java

    # Fix version number (out of date at time of import), and path to
    # jHiccup.jar
    for x in ./jHiccup ./jHiccupLogProcessor; do
      substituteInPlace $x \
        --replace 'JHICCUP_Version=2.0.5' 'JHICCUP_Version=${version}' \
        --replace '$INSTALLED_PATH' $out/share/java
    done

    mv jHiccup jHiccupLogProcessor $out/bin/
  '';

  meta = {
    description = "Measure JVM application stalls and GC pauses";
    homepage    = https://www.azul.com/jhiccup/;
    license     = stdenv.lib.licenses.cc0;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
