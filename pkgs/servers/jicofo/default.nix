{ pkgs, stdenv, fetchurl, dpkg, jre_headless, nixosTests }:

let
  pname = "jicofo";
  version = "1.0-589";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "0bsagnmw2rxf9s9kjl4y7gfqx408iv0qlwgy3mz0339g5503p5r9";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  dontBuild = true;

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src debcontents";

  installPhase = ''
    substituteInPlace usr/share/jicofo/jicofo.sh \
      --replace "exec java" "exec ${jre_headless}/bin/java"

    mkdir -p $out/{share,bin}
    mv usr/share/jicofo $out/share/
    mv etc $out/
    cp ${./logging.properties-journal} $out/etc/jitsi/jicofo/logging.properties-journal
    ln -s $out/share/jicofo/jicofo.sh $out/bin/jicofo
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  meta = with stdenv.lib; {
    description = "A server side focus component used in Jitsi Meet conferences";
    longDescription = ''
      JItsi COnference FOcus is a server side focus component used in Jitsi Meet conferences.
    '';
    homepage = "https://github.com/jitsi/jicofo";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
