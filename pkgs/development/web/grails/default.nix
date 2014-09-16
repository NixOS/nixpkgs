{ stdenv, fetchurl, unzip
# If jdkPath is null, require JAVA_HOME in runtime environment, else store
# JAVA_HOME=${jdkPath} into grails.
, jdkPath ? null
, coreutils, ncurses, gnused, gnugrep  # for purity
}:

let
  binpath = stdenv.lib.makeSearchPath "bin"
    ([ coreutils ncurses gnused gnugrep ]
    ++ stdenv.lib.optional (jdkPath != null) jdkPath);
in
stdenv.mkDerivation rec {
  name = "grails-2.4.3";

  src = fetchurl {
    url = "http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/${name}.zip";
    sha256 = "0lqkv0hsiiqa36pfnq5wv7s7nsp9xadmh1ri039bn0llpfck4742";
  };

  buildInputs = [ unzip ];

  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out"
    cp -vr . "$out"
    # Remove (for now) uneeded Windows .bat files
    rm -f "$out"/bin/*.bat
    # Improve purity
    sed -i -e '2iPATH=${binpath}:\$PATH' "$out"/bin/grails
  '' + stdenv.lib.optionalString (jdkPath != null) ''
    # Inject JDK path into grails
    sed -i -e '2iJAVA_HOME=${jdkPath}' "$out"/bin/grails
  '';

  preferLocalBuild = true;

  meta = with stdenv.lib; {
    description = "Full stack, web application framework for the JVM";
    longDescription = ''
      Grails is an Open Source, full stack, web application framework for the
      JVM. It takes advantage of the Groovy programming language and convention
      over configuration to provide a productive and stream-lined development
      experience.
    '';
    homepage = http://grails.org/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
