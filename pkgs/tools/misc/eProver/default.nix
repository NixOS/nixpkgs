{ stdenv, fetchurl, which, texLive }:

stdenv.mkDerivation {
  name = "EProver-0.999";

  src = fetchurl {
    name = "E-0.999.tar.gz";
    url = http://www4.informatik.tu-muenchen.de/~schulz/WORK/E_DOWNLOAD/V_0.999/E.tgz;
    sha256 = "1zm1xip840hlam60kqk6xf0ikvyk7ch3ql1ac6wb68dx2l6hyhxv";
  };

  buildInputs = [which texLive];

  preConfigure = "sed -e 's@^EXECPATH\\s.*@EXECPATH = '\$out'/bin@' -i Makefile.vars";

  buildPhase = "make install";

  # HOME=. allows to build missing TeX formats
  installPhase = ''
    mkdir -p $out/bin
    make install-exec
    HOME=. make documentation
    mkdir -p $out/share/doc
    cp -r DOC $out/share/doc/EProver
    echo eproof -xAuto --tstp-in --tstp-out '"$@"' > $out/bin/eproof-tptp
    chmod a+x $out/bin/eproof-tptp
  '';

  meta = {
    description = "E automated theorem prover";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
