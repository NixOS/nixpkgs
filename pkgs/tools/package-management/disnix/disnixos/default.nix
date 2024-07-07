{ lib, stdenv, fetchurl, dysnomia, disnix, socat, pkg-config, getopt }:

stdenv.mkDerivation rec {
  pname = "disnixos";
  version = "0.9.4";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0adv6dm6hszjhzkfkw48pmi37zj32plcibk80r6bm907mm7n50lj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ socat dysnomia disnix getopt ];

  meta = {
    description = "Provides complementary NixOS infrastructure deployment to Disnix";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.linux;
  };
}
