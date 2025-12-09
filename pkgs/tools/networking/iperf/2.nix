{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iperf";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/iperf-${finalAttrs.version}.tar.gz";
    hash = "sha256-dUqwp+KAM9vqgTCO9CS8ffTW4v4xtgzFNrYbUf772Ps=";
  };

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
})
