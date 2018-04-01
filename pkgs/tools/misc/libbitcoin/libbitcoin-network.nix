{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, libbitcoin, zeromq }:

let
  pname = "libbitcoin-network";
  version = "3.5.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vqg3i40kwmbys4lyp82xvg2nx3ik4qhc66gcm8k66a86wpj9ji6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libbitcoin zeromq ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin P2P Network Library";
    homepage = https://libbitcoin.org/;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ asymmetric ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
