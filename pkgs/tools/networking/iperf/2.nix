{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "2.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${pname}-${version}.tar.gz";
    sha256 = "1h3qyd53hnk73653nbz08bai2wb0x4hz8pwhrnjq6yqckbaadv26";
  };

  hardeningDisable = [ "format" ];
  configureFlags = [ "--enable-fastsampling" ];

  postInstall = ''
    mv $out/bin/iperf $out/bin/iperf2
    ln -s $out/bin/iperf2 $out/bin/iperf
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    license = licenses.mit;

    # prioritize iperf3
    priority = 10;
  };
}
