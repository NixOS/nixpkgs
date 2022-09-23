{ lib, stdenv, fetchurl, dysnomia, disnix, socat, pkg-config, getopt }:

stdenv.mkDerivation rec {
  pname = "disnixos";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0nm7g184xh6xzjz4a40a7kgfnpmq043x6v0cynpffa6wd9jv89s9";
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
