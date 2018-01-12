{ stdenv, lib, fetchFromGitHub, pkgconfig, autoreconfHook
, boost, libbitcoin-client, libbitcoin-network }:

let
  pname = "libbitcoin-explorer";
  version = "3.4.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rxiimklzqyp9vswznz9aia71dn6jxm2pxx5ljlhzs5rs583cj00";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libbitcoin-client libbitcoin-network ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-bash-completiondir=$out/share/bash-completion/completions"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin command line tool";
    homepage = https://github.com/libbitcoin/libbitcoin-explorer;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin asymmetric ];

    # AGPL with a lesser clause
    license = licenses.agpl3;
  };
}
