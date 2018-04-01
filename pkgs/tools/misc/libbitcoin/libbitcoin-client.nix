{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, libbitcoin, libbitcoin-protocol }:

let
  pname = "libbitcoin-client";
  version = "3.5.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a9c00f1pfi8wczbfd1djkvr7di3iw1ynak6if910w01dkhbm6v4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ libbitcoin libbitcoin-protocol ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin client query library";
    homepage = https://github.com/libbitcoin/libbitcoin-client;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
