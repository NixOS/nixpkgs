{ lib, stdenv, fetchurl, cmake, pkg-config, openssl, libxml2, boost, python3, libuuid }:

stdenv.mkDerivation rec {
  version = "0.7.6";
  pname = "davix";
  nativeBuildInputs = [ cmake pkg-config python3 ];
  buildInputs = [ openssl libxml2 boost libuuid ];

  # using the url below since the github release page states
  # "please ignore the GitHub-generated tarballs, as they are incomplete"
  # https://github.com/cern-fts/davix/releases/tag/R_0_7_6
  src = fetchurl {
    url = "https://github.com/cern-fts/${pname}/releases/download/R_${lib.replaceStrings ["."] ["_"] version}/${pname}-${version}.tar.gz";
    sha256 = "0wq66spnr616cns72f9dvr2xfvkdvfqqmc6d7dx29fpp57zzvrx2";
  };


  meta = with lib; {
    description = "Toolkit for Http-based file management";

    longDescription = "Davix is a toolkit designed for file
    operations with Http based protocols (WebDav, Amazon S3, ...).
    Davix provides an API and a set of command line tools";

    license     = licenses.lgpl2Plus;
    homepage    = "http://dmc.web.cern.ch/projects/davix/home";
    maintainers = [ maintainers.adev ];
    platforms   = platforms.all;
  };
}

