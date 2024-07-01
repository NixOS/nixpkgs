{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "iperf";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/iperf2/files/${pname}-${version}.tar.gz";
    sha256 = "16810a9575e4c6dd65e4a18ab5df3cdac6730b3c832cf080a8990f132f68364a";
  };

  hardeningDisable = [ "format" ];
  #configureFlags = [ "--enable-fastsampling" ];

  makeFlags = [ "AR:=$(AR)" ];

  postInstall = ''
    mv $out/bin/iperf $out/bin/iperf2
    ln -s $out/bin/iperf2 $out/bin/iperf
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/iperf2/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = platforms.unix;
    # broadcom license
    # https://sourceforge.net/p/iperf2/code/ci/master/tree/LICENSE
    #license = licenses.mit;
  };
}
