{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "2.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${pname}-${version}.tar.gz";
    sha256 = "1yflnj2ni988nm0p158q8lnkiq2gn2chmvsglyn2gqmqhwp3jaq6";
  };

  hardeningDisable = [ "format" ];
  configureFlags = [ "--enable-fastsampling" ];

  makeFlags = [ "AR:=$(AR)" ];

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
