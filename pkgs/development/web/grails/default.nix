{ lib, stdenv, fetchurl, unzip
# If jdk is null, require JAVA_HOME in runtime environment, else store
# JAVA_HOME=${jdk.home} into grails.
, jdk ? null
, coreutils, ncurses, gnused, gnugrep  # for purity
}:

let
  binpath = lib.makeBinPath
    ([ coreutils ncurses gnused gnugrep ] ++ lib.optional (jdk != null) jdk);
in
stdenv.mkDerivation rec {
  pname = "grails";
  version = "4.1.0.M1";

  src = fetchurl {
    url = "https://github.com/grails/grails-core/releases/download/v${version}/grails-${version}.zip";
    sha256 = "0l99x3g485qjpdd7ga553xpi1s6rq21p8v16qjzqwdhyld961qsr";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out"
    cp -vr . "$out"
    # Remove (for now) uneeded Windows .bat files
    rm -f "$out"/bin/*.bat
    # Improve purity
    sed -i -e '2iPATH=${binpath}:\$PATH' "$out"/bin/grails
  '' + lib.optionalString (jdk != null) ''
    # Inject JDK path into grails
    sed -i -e '2iJAVA_HOME=${jdk.home}' "$out"/bin/grails
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Full stack, web application framework for the JVM";
    longDescription = ''
      Grails is an Open Source, full stack, web application framework for the
      JVM. It takes advantage of the Groovy programming language and convention
      over configuration to provide a productive and stream-lined development
      experience.
    '';
    homepage = "https://grails.org/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
