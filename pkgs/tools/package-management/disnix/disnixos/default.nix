{ lib, stdenv, fetchurl, dysnomia, disnix, socat, pkg-config, getopt }:

stdenv.mkDerivation {
  name = "disnixos-0.9";

  src = fetchurl {
    url = "https://github.com/svanderburg/disnixos/releases/download/disnixos-0.9/disnixos-0.9.tar.gz";
    sha256 = "0vllm5a8d9dvz5cjiq1mmkc4r4vnljabq42ng0ml85sjn0w7xvm7";
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
