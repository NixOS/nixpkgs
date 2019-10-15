{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "iperf-2.0.13";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${name}.tar.gz";
    sha256 = "1bbq6xr0vrd88zssfiadvw3awyn236yv94fsdl9q2sh9cv4xx2n8";
  };

  hardeningDisable = [ "format" ];
  configureFlags = [ "--enable-fastsampling" ];

  postInstall = ''
    mv $out/bin/iperf $out/bin/iperf2
    ln -s $out/bin/iperf2 $out/bin/iperf
  '';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/iperf/;
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;

    # prioritize iperf3
    priority = 10;
  };
}
