{ stdenv, fetchgit, makeWrapper, ant, jdk, bcprov } :
stdenv.mkDerivation {
  name = "android-backup-extractor-git-2015-06-12";
  src = fetchgit {
    url = "https://github.com/nelenkov/android-backup-extractor.git";
    rev = "434afd12e8b59aa335888352c1ab5756c7778061";
    sha256 = "a6da00c8fcc5a4ff0a4498fe03c67f8b18b1755546061969adc58ba168f38eb9";
  };
  nativeBuildInputs = [ ant jdk makeWrapper ];
  buildPhase = "
    # build.xml expects this name for the bcprov library
    ln -s ${bcprov}/share/java/*.jar lib/bcprov-jdk15on-150.jar
    ant
  ";
  installPhase = ''
    mkdir -p $out/bin $out/lib/android-backup-extractor
    cp abe.jar $out/lib/android-backup-extractor
    makeWrapper ${jdk.jre}/bin/java $out/bin/abe --add-flags "-cp $out/lib/android-backup-extractor/abe.jar org.nick.abe.Main"
  '';
  meta = {
    description = "Utility to extract and repack Android backups created with adb backup";
    homepage = "https://github.com/nelenkov/android-backup-extractor";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
  };
}
