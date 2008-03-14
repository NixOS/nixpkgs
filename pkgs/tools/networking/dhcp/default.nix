{ stdenv, fetchurl, groff, nettools, coreutils, iputils, gnused,
  bash, makeWrapper }:

stdenv.mkDerivation {
  name = "dhcp-3.0.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.isc.org/isc/dhcp/dhcp-3.0.6.tar.gz;
    sha256 = "0k8gy3ab9kzs4qcc9apgnxi982lhggha41fkw9w1bmvmz7mv0xwz";
  };
  buildInputs = [ groff nettools makeWrapper ];
#  inherit nettools coreutils iputils gnused bash;
  patches = [ ./resolv-without-domain.patch ./no-mkdir-var-run.patch ];

  postInstall = ''
    wrapProgram "$out/sbin/dhclient-script" --prefix PATH : \
      "${nettools}/bin:${nettools}/sbin"
  '';

  meta = {
    description = ''ISC's Dynamic Host Configuration Protocol (DHCP)
                    distribution provides a freely redistributable reference
		    implementation of all aspects of DHCP, through a suite
		    of DHCP tools: server, client, and relay agent.'';
    homepage = http://www.isc.org/products/DHCP/;
    license = "http://www.isc.org/sw/dhcp/dhcp-copyright.php";
  };
}
