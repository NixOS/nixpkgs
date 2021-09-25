{ lib
, stdenv
, fetchFromGitHub, fetchpatch
, autoreconfHook
, pkg-config
, libtasn1, openssl, fuse, glib, libseccomp, json-glib
, libtpms
, unixtools, expect, socat
, gnutls
, perl
}:

stdenv.mkDerivation rec {
  pname = "swtpm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${version}";
    sha256 = "sha256-7YzdwGAGECj7PhaCOf/dLSILPXqtbylCkN79vuFBw5Y=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/stefanberger/swtpm/pull/527.patch";
      sha256 = "sha256-cpKHP15a27ifmmswSgHoNzGPO6TY/ZuJIfM5xLOlqlU=";
    })
  ];

  nativeBuildInputs = [
    pkg-config unixtools.netstat expect socat
    perl # for pod2man
    autoreconfHook
  ];
  buildInputs = [
    libtpms
    openssl libtasn1 libseccomp
    fuse glib json-glib
    gnutls
  ];

  configureFlags = [
    "--with-cuse"
  ];

  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
