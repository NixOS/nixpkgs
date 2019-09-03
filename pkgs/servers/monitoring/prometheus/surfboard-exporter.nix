{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "surfboard_exporter";
  version = "2.0.0";

  goPackagePath = "github.com/ipstatic/surfboard_exporter";

  src = fetchFromGitHub {
    rev = version;
    owner = "ipstatic";
    repo = "surfboard_exporter";
    sha256 = "11qms26648nwlwslnaflinxcr5rnp55s908rm1qpnbz0jnxf5ipw";
  };

  meta = with stdenv.lib; {
    description = "Arris Surfboard signal metrics exporter";
    homepage = https://github.com/ipstatic/surfboard_exporter;
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler ];
    platforms = platforms.unix;
  };
}
