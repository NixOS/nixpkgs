{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${pname}-${version}.tar.gz";
    sha256 = "1yyqzgz526xn6v2hrdiizviddx3xphjg93ihh7mdncw0wakv0jkm";
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
