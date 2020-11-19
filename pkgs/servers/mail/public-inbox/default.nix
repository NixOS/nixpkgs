{ stdenv, lib, fetchurl, makeWrapper
, gcc, git, gnumake, openssl, xapian
, buildPerlPackage
, coreutils
, curl
, git
, gnumake
, highlight
, libgit2
, man
, openssl
, pkg-config
, sqlite
, xapian
, AnyURIEscape
, DBDSQLite
, DBI
, EmailAddressXS
, EmailMIME
, highlight
, IOSocketSSL
, IPCRun
, Inline
, InlineC
, ParseRecDescent
, Plack
, PlackMiddlewareReverseProxy
, SearchXapian
, TimeDate
, URI
}:

let

  skippedTests = [
    # These tests would fail, and produce "Operation not permitted"
    # errors from git, because they use git init --shared.  This tries
    # to set the setgid bit, which isn't permitted inside build
    # sandboxes.
    #
    # These tests were indentified with
    #     grep -r shared t/
    "convert-compact" "search" "v2writable" "www_listing"
    # perl5.32.0-public-inbox> t/eml.t ...................... 1/? Cannot parse parameter '=?ISO-8859-1?Q?=20charset=3D=1BOF?=' at t/eml.t line 270.
    # perl5.32.0-public-inbox> #   Failed test 'got wide character by assuming utf-8'
    # perl5.32.0-public-inbox> #   at t/eml.t line 272.
    # perl5.32.0-public-inbox> Wide character in print at /nix/store/38vxlxrvg3yji3jms44qn94lxdysbj5j-perl-5.32.0/lib/perl5/5.32.0/Test2/Formatter/TAP.pm line 125.
    "eml"
    # Failed test 'Makefile OK'
    # at t/hl_mod.t line 19.
    #        got: 'makefile'
    #   expected: 'make'
    "hl_mod"
  ];

  testConditions = with lib;
    concatMapStringsSep " " (n: "! -name ${escapeShellArg n}.t") skippedTests;

in

buildPerlPackage rec {
  pname = "public-inbox";
  version = "1.6.1";

  src = fetchurl {
    url = "https://public-inbox.org/public-inbox.git/snapshot/public-inbox-${version}.tar.gz";
    sha256 = "0mr8f8qv15l0lx94im9084lmsw1qh8lzyb7mj1s5yhpw48k25709";
  };

  outputs = [ "out" "devdoc" "sa_config" ];

  postConfigure = ''
    substituteInPlace Makefile --replace 'TEST_FILES = t/*.t' \
        'TEST_FILES = $(shell find t -name *.t ${testConditions})'
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    AnyURIEscape
    DBDSQLite
    DBI
    EmailAddressXS
    EmailMIME
    highlight
    IOSocketSSL
    IPCRun
    Inline
    InlineC
    ParseRecDescent
    Plack
    PlackMiddlewareReverseProxy
    SearchXapian
    TimeDate
    URI
  ];

  checkInputs = [ git openssl xapian ];
  preCheck = ''
    perl certs/create-certs.perl
  '';

  installTargets = [ "install" ];
  postInstall = ''
    for prog in $out/bin/*; do
        wrapProgram $prog --prefix PATH : ${lib.makeBinPath [
          git
          /* for InlineC */
          gnumake
          stdenv.cc.cc
        ]}
    done

    mv sa_config $sa_config
  '';

  meta = with lib; {
    homepage = "https://public-inbox.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ qyliss julm ];
    platforms = platforms.all;
  };
}
