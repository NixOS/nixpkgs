{ buildPerlPackage, lib, fetchurl, makeWrapper
, DBDSQLite, EmailMIME, IOSocketSSL, IPCRun, Plack, PlackMiddlewareReverseProxy
, SearchXapian, TimeDate, URI
, git, highlight, openssl, xapian
}:

let

  # These tests would fail, and produce "Operation not permitted"
  # errors from git, because they use git init --shared.  This tries
  # to set the setgid bit, which isn't permitted inside build
  # sandboxes.
  #
  # These tests were indentified with
  #     grep -r shared t/
  skippedTests = [ "convert-compact" "search" "v2writable" "www_listing" ];

  testConditions = with lib;
    concatMapStringsSep " " (n: "! -name ${escapeShellArg n}.t") skippedTests;

in

buildPerlPackage rec {
  pname = "public-inbox";
  version = "1.2.0";

  src = fetchurl {
    url = "https://public-inbox.org/releases/public-inbox-${version}.tar.gz";
    sha256 = "0sa2m4f2x7kfg3mi4im7maxqmqvawafma8f7g92nyfgybid77g6s";
  };

  outputs = [ "out" "devdoc" "sa_config" ];

  postConfigure = ''
    substituteInPlace Makefile --replace 'TEST_FILES = t/*.t' \
        'TEST_FILES = $(shell find t -name *.t ${testConditions})'
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    DBDSQLite EmailMIME IOSocketSSL IPCRun Plack PlackMiddlewareReverseProxy
    SearchXapian TimeDate URI highlight
  ];

  checkInputs = [ git openssl xapian ];
  preCheck = ''
    perl certs/create-certs.perl
  '';

  installTargets = [ "install" ];
  postInstall = ''
    for prog in $out/bin/*; do
        wrapProgram $prog --prefix PATH : ${lib.makeBinPath [ git ]}
    done

    mv sa_config $sa_config
  '';

  meta = with lib; {
    homepage = "https://public-inbox.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
  };
}
