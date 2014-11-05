{ stdenv, fetchgit, cmake, libgcrypt, json_c, curl, expat, boost, binutils }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "grive-${version}";

  src = fetchgit {
    url = "https://github.com/Grive/grive.git";
    rev = "51e42914f3666ee6e0bc16a4c78f60b117265c24";
    sha256 = "f2b978cc93a2d16262c7b78c62019b2a58044eaef4ca95feaa74dfd4dfcbfa36";
  };

  buildInputs = [cmake libgcrypt json_c curl expat stdenv binutils boost];

  # work around new binutils headers, see
  # http://stackoverflow.com/questions/11748035/binutils-bfd-h-wants-config-h-now
  prePatch = ''
    sed -i '1i#define PACKAGE "grive"\n#define PACKAGE_VERSION "${version}"' \
      libgrive/src/bfd/SymbolInfo.cc
  '';

  meta = {
    description = "an open source (experimental) Linux client for Google Drive";
    homepage = https://github.com/Grive/grive;
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.all;
  };
}
