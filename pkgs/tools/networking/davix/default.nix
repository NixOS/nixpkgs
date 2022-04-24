{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, openssl
, libxml2
, boost
, python3
, libuuid
, curl
, gsoap
, enableTools ? true
  # Build the bundled libcurl
  # and, if defaultToLibCurl,
  # use instead of an external one
, useEmbeddedLibcurl ? true
  # Use libcurl instead of libneon
  # Note that the libneon used is bundled in the project
  # See https://github.com/cern-fts/davix/issues/23
, defaultToLibcurl ? false
, enableIpv6 ? true
, enableTcpNodelay ? true
  # Build davix_copy.so
, enableThirdPartyCopy ? false
}:

let
  boolToUpper = b: lib.toUpper (lib.boolToString b);
in
stdenv.mkDerivation rec {
  version = "0.8.0";
  pname = "davix" + lib.optionalString enableThirdPartyCopy "-copy";
  nativeBuildInputs = [ cmake pkg-config python3 ];
  buildInputs = [
    openssl
    libxml2
    boost
    libuuid
  ] ++ lib.optional (defaultToLibcurl && !useEmbeddedLibcurl) curl
  ++ lib.optional (enableThirdPartyCopy) gsoap;

  # using the url below since the github release page states
  # "please ignore the GitHub-generated tarballs, as they are incomplete"
  # https://github.com/cern-fts/davix/releases/tag/R_0_8_0
  src = fetchurl {
    url = "https://github.com/cern-fts/davix/releases/download/R_${lib.replaceStrings ["."] ["_"] version}/davix-${version}.tar.gz";
    sha256 = "LxCNoECKg/tbnwxoFQ02C6cz5LOg/imNRbDTLSircSQ=";
  };

  preConfigure = ''
    find . -mindepth 1 -maxdepth 1 -type f -name "patch*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done
  '';

  cmakeFlags = [
    "-DENABLE_TOOLS=${boolToUpper enableTools}"
    "-DEMBEDDED_LIBCURL=${boolToUpper useEmbeddedLibcurl}"
    "-DLIBCURL_BACKEND_BY_DEFAULT=${boolToUpper defaultToLibcurl}"
    "-DENABLE_IPV6=${boolToUpper enableIpv6}"
    "-DENABLE_TCP_NODELAY=${boolToUpper enableTcpNodelay}"
    "-DENABLE_THIRD_PARTY_COPY=${boolToUpper enableThirdPartyCopy}"
  ];

  meta = with lib; {
    description = "Toolkit for Http-based file management";

    longDescription = "Davix is a toolkit designed for file
    operations with Http based protocols (WebDav, Amazon S3, ...).
    Davix provides an API and a set of command line tools";

    license = licenses.lgpl2Plus;
    homepage = "https://github.com/cern-fts/davix";
    changelog = "https://github.com/cern-fts/davix/blob/R_${lib.replaceStrings ["."] ["_"] version}/RELEASE-NOTES.md";
    maintainers = with maintainers; [ adev ];
    platforms = platforms.all;
  };
}
