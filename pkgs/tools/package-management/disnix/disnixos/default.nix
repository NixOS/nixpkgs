{ lib, stdenv, fetchurl, dysnomia, disnix, socat, pkg-config, getopt }:

stdenv.mkDerivation rec {
  pname = "disnixos";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "0zcghb9nm911bfwpzcgj4ga2cndxbzp5pmrxff711qydrwgy7sg7";
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
