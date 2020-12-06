{ stdenv, ps, coreutils, fetchurl, jdk, jre, ant, gettext, which }:

let wrapper = stdenv.mkDerivation rec {
  pname = "wrapper";
  version = "3.5.44";

  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${version}/wrapper_${version}_src.tar.gz";
    sha256 = "1iq4j7srzy5p8q3nci9316bnwx4g71jyvzd1i5hp3s8v1k61910g";
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
  pname = "i2p";
  version = "0.9.48";

  src = fetchurl {
    url = "https://download.i2p2.de/releases/${version}/i2psource_${version}.tar.bz2";
    sha256 = "0cnm4bwl1gqcx89i96j2qlq6adphy4l72h5whamqwv86n8bmpig8";
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
    description = "Applications and router for I2P, anonymity over the Internet";
    homepage = "https://geti2p.net";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ joelmo ];
  };
}
