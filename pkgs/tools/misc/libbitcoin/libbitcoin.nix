{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, secp256k1 }:

let
  pname = "libbitcoin";
  version = "3.5.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1qy637hpv6kkhf602yxxi5b9j0qhsp644fazljcqbnxzp7vv2qyd";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  propagatedBuildInputs = [ secp256k1 ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "C++ library for building bitcoin applications";
    homepage = https://libbitcoin.org/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
