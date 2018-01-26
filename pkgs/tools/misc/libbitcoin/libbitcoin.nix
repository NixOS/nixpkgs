{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, secp256k1 }:

let
  pname = "libbitcoin";
  version = "3.4.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1h6h7cxbwkdk8bzbkfvnrrdzajw1d4lr8wqs66is735bksh6gk1y";
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
