{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cabextract";
  version = "1.11";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/cabextract-${version}.tar.gz";
    sha256 = "sha256-tVRtsRVeTHGP89SyeFc2BPMN1kw8W/1GV80Im4I6OsY=";
  };

  # Let's assume that fnmatch works for cross-compilation, otherwise it gives an error:
  # undefined reference to `rpl_fnmatch'.
  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_func_fnmatch_works=yes"
  ];

  meta = with lib; {
    homepage = "https://www.cabextract.org.uk/";
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}
