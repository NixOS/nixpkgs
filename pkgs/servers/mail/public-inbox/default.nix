{ stdenv, lib, fetchurl, makeWrapper, nixosTests
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
, IOSocketSSL
, IPCRun
, Inline
, InlineC
, LinuxInotify2
, MailIMAPClient
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
    # Failed test 'clone + index v1 synced ->created_at'
    # at t/lei-mirror.t line 175.
    #        got: '1638378723'
    #   expected: undef
    # Failed test 'clone + index v1 synced ->created_at'
    # at t/lei-mirror.t line 178.
    #        got: '1638378723'
    #   expected: undef
    # May be due to the use of $ENV{HOME}.
    "lei-mirror"
    # Failed test 'child error (pure-Perl)'
    # at t/spawn.t line 33.
    #        got: '0'
    #   expected: anything else
    # waiting for child to reap grandchild...
    "spawn"
    # TODO: reenable after https://public-inbox.org/meta/20211208010730.f47xxgzj53nwgvja@sourcephile.fr/T/#m38685d23bd686442d91a4890bac3c018d427b96b
    # has been merged
    "lei-sigpipe"
    # Fails at least when TMPDIR is on ZFS
    "lei_to_mail"
    # Disabled after 1.7.0
    # https://public-inbox.org/public-inbox.git/commit/?id=7cb1f806dfa0173fb689048c56a755cb3874dcaf
    "lei-watch"
    "lei-auto-watch"
  ];

  testConditions = with lib;
    concatMapStringsSep " " (n: "! -name ${escapeShellArg n}.t") skippedTests;

in

buildPerlPackage rec {
  pname = "public-inbox";
  version = "1.7.0";

  src = fetchurl {
    url = "https://public-inbox.org/public-inbox.git/snapshot/public-inbox-${version}.tar.gz";
    sha256 = "sha256-hQSpmAFFVuPmXZvc7q6yP5Zhl86oar83OLYFn+42yMk=";
  };

  outputs = [ "out" "devdoc" "sa_config" ];

  postConfigure = ''
    substituteInPlace Makefile --replace 'TEST_FILES = t/*.t' \
        'TEST_FILES = $(shell find t -name *.t ${testConditions})'
    substituteInPlace lib/PublicInbox/TestCommon.pm \
      --replace /bin/cp ${coreutils}/bin/cp
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
    libgit2 # For Gcf2
    man
  ];

  checkInputs = [
    MailIMAPClient
    curl
    git
    openssl
    pkg-config
    sqlite
    xapian
  ] ++ lib.optionals stdenv.isLinux [
    LinuxInotify2
  ];
  preCheck = ''
    perl certs/create-certs.perl
    export HOME="$NIX_BUILD_TOP"/home
    mkdir -p "$HOME"/.cache/public-inbox/inline-c
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

  passthru.tests = {
    nixos-public-inbox = nixosTests.public-inbox;
  };

  meta = with lib; {
    homepage = "https://public-inbox.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ julm qyliss ];
    platforms = platforms.all;
  };
}
