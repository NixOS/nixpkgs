{ stdenv, fetchurl, which }:

stdenv.mkDerivation {
  name = "ossec-client-2.6";

  src = fetchurl {
    url = http://www.ossec.net/files/ossec-hids-2.6.tar.gz;

    sha256 = "0k1b59wdv9h50gbyy88qw3cnpdm8hv0nrl0znm92h9a11i5b39ip";
  };

  buildInputs = [ which ];

  phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  patches = [ ./no-root.patch ];

  buildPhase = ''
    echo "en

agent
$out
no
127.0.0.1
yes
yes
yes


"   | ./install.sh
  '';

  meta = {
    description = "Open soruce host-based instrusion detection system";
    homepage = http://www.ossec.net;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}

