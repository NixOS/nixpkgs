{ stdenv, fetchgit, cmake, libgcrypt, json_c, curl, expat, boost, binutils }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "grive-${version}";

  src = fetchgit {
    url = "https://github.com/Grive/grive.git";
    rev = "51e42914f3666ee6e0bc16a4c78f60b117265c24";
    sha256 = "11cqfcjl128nfg1rjvpvr9x1x2ch3kyliw4vi14n51zqp82f9ysb";
  };

  buildInputs = [cmake libgcrypt json_c curl expat stdenv binutils boost];

  # work around new binutils headers, see
  # http://stackoverflow.com/questions/11748035/binutils-bfd-h-wants-config-h-now
  prePatch = ''
    sed -i '1i#define PACKAGE "grive"\n#define PACKAGE_VERSION "${version}"' \
      libgrive/src/bfd/SymbolInfo.cc
  '';

  meta = {
    description = "An open source (experimental) Linux client for Google Drive";
    homepage = https://github.com/Grive/grive;
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
  };
}
