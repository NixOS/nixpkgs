{ stdenv, fetchFromGitHub, jre_headless, jdk, ant, saxon }:

stdenv.mkDerivation rec {
  name = "jing-trang-${version}";
  version = "20150603";

  src = fetchFromGitHub {
    owner = "relaxng";
    repo = "jing-trang";
    rev = "54b9b1f4e67cd79c7987750d8c9dcfc014af98c3"; # needed to compile with jdk8
    sha256 = "0wa569xjb7ihhcaazz32y2b0dv092lisjz77isz1gfb1wvf53di5";
  };

  buildInputs = [ jdk ant saxon ];

  preBuild = "ant";

  installPhase = ''
    mkdir -p "$out"/{share/java,bin}
    cp ./build/*.jar "$out/share/java/"

    for tool in jing trang; do
    cat > "$out/bin/$tool" <<EOF
    #! $SHELL
    export JAVA_HOME='${jre_headless}'
    exec '${jre_headless}/bin/java' -jar '$out/share/java/$tool.jar' "\$@"
    EOF
    done

    chmod +x "$out"/bin/*
  '';

  meta = with stdenv.lib; {
    description = "A RELAX NG validator in Java";
    # The homepage is www.thaiopensource.com, but it links to googlecode.com
    # for downloads and call it the "project site".
    homepage = http://www.thaiopensource.com/relaxng/jing.html;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
