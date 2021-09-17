{ lib, stdenv, fetchurl, dysnomia, disnix, socat, pkg-config, getopt }:

stdenv.mkDerivation rec {
  pname = "disnixos";
  version = "0.9.1";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/disnixos-${version}/disnixos-${version}.tar.gz";
    sha256 = "1n2psq1b8bg340i2i0yf5xy2rf78fwqd3wj342wcmq09cv2v8d1b";
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
