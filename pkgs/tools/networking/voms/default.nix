{ lib
, stdenv
, fetchFromGitHub
  # Native build inputs
, autoreconfHook
, bison
, flex
, pkg-config
  # Build inputs
, expat
, gsoap
, openssl
, zlib
  # Configuration overridable with .override
  # If not null, the builder will
  # create a new output "etc", move "$out/etc" to "$etc/etc"
  # and symlink "$out/etc" to externalEtc.
, externalEtc ? "/etc"
}:

stdenv.mkDerivation rec{
  pname = "voms-unstable";
  version = "2022-06-14";

  src = fetchFromGitHub {
    owner = "italiangrid";
    repo = "voms";
    rev = "8e99bb96baaf197f0f557836e2829084bb1bb00e"; # develop branch
    hash = "sha256-FG4fHO2lsQ3t/ZaKT9xY+xqdQHfdtzi5ULtxLhdPnss=";
  };

  passthru = {
    inherit externalEtc;
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    expat
    gsoap
    openssl
    zlib
  ];

  outputs = [ "bin" "out" "dev" "man" ]
    ++ lib.optional (externalEtc != null) "etc";

  preAutoreconf = ''
    mkdir -p aux src/autogen
  '';

  postAutoreconf = ''
    # FHS patching
    substituteInPlace configure \
      --replace "/usr/bin/soapcpp2" "${gsoap}/bin/soapcpp2"

    # Tell gcc about the location of zlib
    # See https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=voms
    export GSOAP_SSL_PP_CFLAGS="$(pkg-config --cflags gsoapssl++ zlib)"
    export GSOAP_SSL_PP_LIBS="$(pkg-config --libs gsoapssl++ zlib)"
  '';

  configureFlags = [
    "--with-gsoap-wsdl2h=${gsoap}/bin/wsdl2h"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postFixup = lib.optionalString (externalEtc != null) ''
    moveToOutput etc "$etc"
    ln -s ${lib.escapeShellArg externalEtc} "$out/etc"
  '';

  meta = with lib; {
    description = "C/C++ VOMS server, client and APIs v2.x";
    homepage = "https://italiangrid.github.io/voms/";
    changelog = "https://github.com/italiangrid/voms/blob/master/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.linux; # gsoap is currently Linux-only in Nixpkgs
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
