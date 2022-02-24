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
}:

stdenv.mkDerivation rec{
  pname = "voms-unstable";
  version = "2021-05-04";

  src = fetchFromGitHub {
    owner = "italiangrid";
    repo = "voms";
    rev = "61563152fce3a4e6860dd8ab8ab6e72b7908d8b8";
    sha256 = "LNR0G4XrgxqjQmjyaKoZJLNoxtAGiTM93FG3jIU1u+Y=";
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

  outputs = [ "bin" "out" "dev" "man" ];

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
  ];

  meta = with lib; {
    description = "The VOMS native service and APIs";
    homepage = "https://italiangrid.github.io/voms/";
    changelog = "https://github.com/italiangrid/voms/blob/master/ChangeLog";
    license = licenses.asl20;
    platforms = platforms.linux; # gsoap is currently Linux-only in Nixpkgs
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
