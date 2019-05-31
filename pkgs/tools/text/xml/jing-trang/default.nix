{ stdenv, fetchFromGitHub, jre_headless, jdk, ant, saxon }:

stdenv.mkDerivation rec {
  name = "jing-trang-${version}";
  version = "20151127";

  src = fetchFromGitHub {
    owner = "relaxng";
    repo = "jing-trang";
    rev = "47a0cbdaec2d48824b78a1c19879ac7875509598"; # needed to compile with jdk8
    sha256 = "1hhn52z9mv1x9nyvyqnmzg5yrs2lzm9xac7i15izppv02wp32qha";
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
    homepage = https://www.thaiopensource.com/relaxng/trang.html;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
