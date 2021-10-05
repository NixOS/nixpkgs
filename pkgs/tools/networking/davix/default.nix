{ lib, stdenv, fetchurl, cmake, pkg-config, openssl, libxml2, boost, python3, libuuid }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  pname = "davix";
  nativeBuildInputs = [ cmake pkg-config python3 ];
  buildInputs = [ openssl libxml2 boost libuuid ];

  # using the url below since the github release page states
  # "please ignore the GitHub-generated tarballs, as they are incomplete"
  # https://github.com/cern-fts/davix/releases/tag/R_0_8_0
  src = fetchurl {
    url = "https://github.com/cern-fts/${pname}/releases/download/R_${lib.replaceStrings ["."] ["_"] version}/${pname}-${version}.tar.gz";
    sha256 = "LxCNoECKg/tbnwxoFQ02C6cz5LOg/imNRbDTLSircSQ=";
  };

  preConfigure = ''
    find . -mindepth 1 -maxdepth 1 -type f -name "patch*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done
  '';

  meta = with lib; {
    description = "Toolkit for Http-based file management";

    longDescription = "Davix is a toolkit designed for file
    operations with Http based protocols (WebDav, Amazon S3, ...).
    Davix provides an API and a set of command line tools";

    license = licenses.lgpl2Plus;
    homepage = "http://dmc.web.cern.ch/projects/davix/home";
    changelog = "https://github.com/cern-fts/davix/blob/devel/RELEASE-NOTES.md";
    maintainers = with maintainers; [ adev ];
    platforms = platforms.all;
  };
}
