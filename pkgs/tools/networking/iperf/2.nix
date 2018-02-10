{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.10";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${name}.tar.gz";
    sha256 = "1whyi7lxrkllmbs7i1avc6jq8fvirn64mhx9197bf4x3rj6k9r3z";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
