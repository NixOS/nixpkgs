{ stdenv, fetchgit, cmake, libgcrypt, json_c, curl, expat, boost, binutils }:

stdenv.mkDerivation rec {
  name = "grive-0.2.0";

  src = fetchgit {
    url = "https://github.com/Grive/grive.git";
    rev = "34cb3705288aa83283b370118776ac89393ae5fc";
    sha256 = "a30ea886bdc159e1004d1207fcac30c277f1177a3b846bdd82326eebff7a0bbe";
  };

  buildInputs = [cmake libgcrypt json_c curl expat stdenv binutils boost];

  meta = {
    description = "an open source (experimental) Linux client for Google Drive";
    homepage = https://github.com/Grive/grive;
    license = "GPLv2";

    platforms = stdenv.lib.platforms.all;
  };
}
