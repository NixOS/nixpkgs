{ stdenv, lib, fetchurl, pkgconfig, autoreconfHook
, boost, libsodium, czmqpp, libbitcoin }:

let
  pname = "libbitcoin-client";
  version = "2.2.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/libbitcoin/libbitcoin-client/archive/v${version}.tar.gz";
    sha256 = "1g79hl6jmf5dam7vq19h4dgdj7gcn19fa7q78vn573mg2rdyal53";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ];

  propagatedBuildInputs = [ libsodium czmqpp libbitcoin ];

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-bash-completiondir=$out/share/bash-completion/completions"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin client query library";
    homepage = https://github.com/libbitcoin/libbitcoin-client;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];

    # https://wiki.unsystem.net/en/index.php/Libbitcoin/License
    # AGPL with an additional clause
    license = licenses.agpl3;
  };
}
