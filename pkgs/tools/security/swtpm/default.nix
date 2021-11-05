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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "swtpm";
    rev = "v${version}";
    sha256 = "sha256-iy8xjKnPLq1ntZa9x+KtLDznzu6m+1db3NPeGQESUVo=";
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
    "--localstatedir=/var"
  ];

  prePatch = ''
    # Makefile tries to create the directory /var/lib/swtpm-localca, which fails
    substituteInPlace samples/Makefile.am \
        --replace 'install-data-local:' 'do-not-execute:'

    # Use the correct path to the certtool binary
    # instead of relying on it being in the environment
    substituteInPlace samples/swtpm_localca.c --replace \
        '# define CERTTOOL_NAME "certtool"' \
        '# define CERTTOOL_NAME "${gnutls}/bin/certtool"'
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

  meta = with lib; {
    description = "Libtpms-based TPM emulator";
    homepage = "https://github.com/stefanberger/swtpm";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
