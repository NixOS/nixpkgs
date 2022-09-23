{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, boost, secp256k1 }:

let
  pname = "libbitcoin";
  version = "3.6.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1rppyp3zpb6ymwangjpblwf6qh4y3d1hczrjx8aavmrq7hznnrhq";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  propagatedBuildInputs = [ secp256k1 ];

  enableParallelBuilding = true;

  patches = [ ./fix-gcc11-compilation.patch ];

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "C++ library for building bitcoin applications";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
