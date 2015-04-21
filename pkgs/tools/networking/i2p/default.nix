{ stdenv, procps, coreutils, fetchurl, openjdk8, openjre, ant, gcj, gettext }:

stdenv.mkDerivation rec {
  name = "i2p-0.9.18";
  src = fetchurl {
    url = "https://github.com/i2p/i2p.i2p/archive/${name}.tar.gz";
    sha256 = "1hahdzvfh1zqb8qdc59xbjpqm8qq95k2xx22mpnhcdh90lb6xqnl";
  };
  buildInputs = [ openjdk8 ant gettext ];
  buildPhase = ''
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    ant preppkg-linux-only
    '';
  installPhase = ''
    set -B
    mkdir -p $out/{bin,share}
    cp -r pkg-temp/* $out
    cp installer/lib/wrapper/linux64/* $out
    sed -i $out/i2prouter -i $out/runplain.sh \
      -e "s#%INSTALL_PATH#$out#" \
      -e "s#/usr/ucb/ps#${procps}/bin/ps#" \
      -e "s#/usr/bin/tr#${coreutils}/bin/tr#" \
      -e 's#%USER_HOME#$HOME#' \
      -e "s#%SYSTEM_java_io_tmpdir#/tmp#" \
      -e 's#JAVA=java#JAVA=${openjre}/bin/java#'
    mv $out/runplain.sh $out/bin/i2prouter-plain
    mv $out/man $out/share/
    chmod +x $out/bin/* $out/i2psvc
    rm $out/{osid,postinstall.sh,INSTALL-headless.txt}
    '';

  meta = with stdenv.lib; {
    homepage = "https://geti2p.net";
    description = "Applications and router for I2P, anonymity over the Internet";
    maintainers = [ stdenv.lib.maintainers.joelmo ];
    license = licenses.gpl2;
    # TODO: support other systems, just copy appropriate lib/wrapper.. to $out
    platforms = [ "x86_64-linux" ];
  };
}
