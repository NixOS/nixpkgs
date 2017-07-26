{ stdenv, fetchFromGitHub, ant, jdk }:

stdenv.mkDerivation rec {
  name = "jdepend-${version}";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "clarkware";
    repo = "jdepend";
    rev = version;
    sha256 = "1sxkgj4k4dhg8vb772pvisyzb8x0gwvlfqqir30ma4zvz3rfz60p";
  };

  nativeBuildInputs = [ ant jdk ];
  buildPhase = "ant jar";

  installPhase = ''
    mkdir -p $out/bin $out/share
    install dist/${name}.jar $out/share

    cat > "$out/bin/jdepend" <<EOF
    #!${stdenv.shell}
    exec ${jdk.jre}/bin/java -classpath "$out/share/*" "\$@"
    EOF
    chmod a+x $out/bin/jdepend
  '';

  meta = with stdenv.lib; {
    description = "Traverses Java class file directories and generates design quality metrics for each Java package";
    homepage = http://www.clarkware.com/software/JDepend.html;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
