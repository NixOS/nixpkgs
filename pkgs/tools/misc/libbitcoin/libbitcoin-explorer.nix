{ stdenv, lib, fetchurl, pkgconfig, autoreconfHook
, boost, libbitcoin-client }:

let
  pname = "libbitcoin-explorer";
  version = "2.2.0";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/libbitcoin/libbitcoin-explorer/archive/v${version}.tar.gz";
    sha256 = "00123vw7rxk0ypdfzk0xwk8q55ll31000mkjqdzl915krsbkbfvp";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ];

  propagatedBuildInputs = [ libbitcoin-client ];

  configureFlags = [
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
    "--with-bash-completiondir=$out/share/bash-completion/completions"
  ];

  meta = with stdenv.lib; {
    description = "Bitcoin command line tool";
    homepage = https://github.com/libbitcoin/libbitcoin-explorer;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ chris-martin ];

    # https://wiki.unsystem.net/en/index.php/Libbitcoin/License
    # AGPL with an additional clause
    license = licenses.agpl3;
  };
}
