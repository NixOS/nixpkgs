{ stdenv, ps, coreutils, fetchurl, jdk, jre, ant, gettext, which }:

let wrapper = stdenv.mkDerivation rec {
  name = "wrapper-${version}";
  version = "3.5.32";
  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${version}/wrapper_${version}_src.tar.gz";
    sha256 = "1v388p5jjbpwybw0zjv5glzny17fwdwppaci2lqcsnm6qw0667f1";
  };
  buildInputs = [ jdk ];
  buildPhase = ''
    export ANT_HOME=${ant}
    export JAVA_HOME=${jdk}/lib/openjdk/jre/
    export JAVA_TOOL_OPTIONS=-Djava.home=$JAVA_HOME
    export CLASSPATH=${jdk}/lib/openjdk/lib/tools.jar
    sed 's/ testsuite$//' -i src/c/Makefile-linux-x86-64.make
    ${if stdenv.isi686 then "./build32.sh" else "./build64.sh"}
  '';
  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp bin/wrapper $out/bin/wrapper
    cp lib/wrapper.jar $out/lib/wrapper.jar
    cp lib/libwrapper.so $out/lib/libwrapper.so
  '';
};

in

stdenv.mkDerivation rec {
  name = "i2p-0.9.33";
  src = fetchurl {
    url = "https://github.com/i2p/i2p.i2p/archive/${name}.tar.gz";
    sha256 = "1hlildi34p34xgpm0gqh09r2jb6nsa7a52gr074r6203xkl2racw";
  };
  buildInputs = [ jdk ant gettext which ];
  patches = [ ./i2p.patch ];
  buildPhase = ''
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    ant preppkg-linux-only
    '';
  installPhase = ''
    set -B
    mkdir -p $out/{bin,share}
    cp -r pkg-temp/* $out

    cp ${wrapper}/bin/wrapper $out/i2psvc
    cp ${wrapper}/lib/wrapper.jar $out/lib
    cp ${wrapper}/lib/libwrapper.so $out/lib

    sed -i $out/i2prouter -i $out/runplain.sh \
      -e "s#uname#${coreutils}/bin/uname#" \
      -e "s#which#${which}/bin/which#" \
      -e "s#%gettext%#${gettext}/bin/gettext#" \
      -e "s#/usr/ucb/ps#${ps}/bin/ps#" \
      -e "s#/usr/bin/tr#${coreutils}/bin/tr#" \
      -e "s#%INSTALL_PATH#$out#" \
      -e 's#%USER_HOME#$HOME#' \
      -e "s#%SYSTEM_java_io_tmpdir#/tmp#" \
      -e "s#%JAVA%#${jre}/bin/java#"
    mv $out/runplain.sh $out/bin/i2prouter-plain
    mv $out/man $out/share/
    chmod +x $out/bin/* $out/i2psvc
    rm $out/{osid,postinstall.sh,INSTALL-headless.txt}
    '';

  meta = with stdenv.lib; {
    homepage = https://geti2p.net;
    description = "Applications and router for I2P, anonymity over the Internet";
    maintainers = [ maintainers.joelmo ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
