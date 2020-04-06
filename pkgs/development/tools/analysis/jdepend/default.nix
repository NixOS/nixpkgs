{ stdenv, fetchFromGitHub, ant, jdk, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "jdepend";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "clarkware";
    repo = "jdepend";
    rev = version;
    sha256 = "1lxf3j9vflky7a2py3i59q7cwd1zvjv2b88l3za39vc90s04dz6k";
  };

  nativeBuildInputs = [ ant jdk ];
  buildPhase = "ant jar";

  installPhase = ''
    mkdir -p $out/bin $out/share
    install dist/${pname}-${version}.jar $out/share

    cat > "$out/bin/jdepend" <<EOF
    #!${runtimeShell}
    exec ${jdk.jre}/bin/java -classpath "$out/share/*" "\$@"
    EOF
    chmod a+x $out/bin/jdepend
  '';

  meta = with stdenv.lib; {
    description = "Traverses Java class file directories and generates design quality metrics for each Java package";
    homepage = "http://www.clarkware.com/software/JDepend.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
