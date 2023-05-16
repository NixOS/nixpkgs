{ stdenv, lib, fetchurl, makeWrapper, nixosTests
, buildPerlPackage
, coreutils
, curl
, git
, gnumake
, highlight
, libgit2
<<<<<<< HEAD
, libxcrypt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
# FIXME: to be packaged
#, IOSocketSocks
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, IPCRun
, Inline
, InlineC
, LinuxInotify2
, MailIMAPClient
<<<<<<< HEAD
# FIXME: to be packaged
#, NetNetrc
# FIXME: to be packaged
#, NetNNTP
, ParseRecDescent
, Plack
, PlackMiddlewareReverseProxy
, PlackTestExternalServer
, SearchXapian
, TestSimple13
, TimeDate
, URI
, XMLTreePP
=======
, ParseRecDescent
, Plack
, PlackMiddlewareReverseProxy
, SearchXapian
, TimeDate
, URI
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let

  skippedTests = [
<<<<<<< HEAD
    # fatal: Could not make /tmp/pi-search-9188-DGZM/a.git/branches/ writable by group
    "search"
=======
    # These tests would fail, and produce "Operation not permitted"
    # errors from git, because they use git init --shared.  This tries
    # to set the setgid bit, which isn't permitted inside build
    # sandboxes.
    #
    # These tests were indentified with
    #     grep -r shared t/
    "convert-compact" "search" "v2writable" "www_listing"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # Hangs on "inbox unlocked on initial fetch, waiting for IDLE".
    # Fixed in HEAD: 7234e671 ("t/imapd: workaround a Perl 5.36.0 readline regression")
    "imapd"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # Failed to connect to 127.0.0.1
    "v2mirror"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  testConditions = with lib;
    concatMapStringsSep " " (n: "! -name ${escapeShellArg n}.t") skippedTests;

in

buildPerlPackage rec {
  pname = "public-inbox";
<<<<<<< HEAD
  version = "1.9.0";

  src = fetchurl {
    url = "https://public-inbox.org/public-inbox.git/snapshot/public-inbox-${version}.tar.gz";
    sha256 = "sha256-ENnT2YK7rpODII9TqiEYSCp5mpWOnxskeSuAf8Ilqro=";
=======
  version = "1.8.0";

  src = fetchurl {
    url = "https://public-inbox.org/public-inbox.git/snapshot/public-inbox-${version}.tar.gz";
    sha256 = "sha256-laJOOCk5NecIGWesv4D30cLGfijQHVkeo55eNqNKzew=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    highlight
    IOSocketSSL
    #IOSocketSocks
    IPCRun
    Inline
    InlineC
    MailIMAPClient
    #NetNetrc
    #NetNNTP
=======
    EmailMIME
    highlight
    IOSocketSSL
    IPCRun
    Inline
    InlineC
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ParseRecDescent
    Plack
    PlackMiddlewareReverseProxy
    SearchXapian
    TimeDate
    URI
    libgit2 # For Gcf2
    man
  ];

  doCheck = !stdenv.isDarwin;
  nativeCheckInputs = [
<<<<<<< HEAD
=======
    MailIMAPClient
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    curl
    git
    openssl
    pkg-config
    sqlite
    xapian
<<<<<<< HEAD
    EmailMIME
    PlackTestExternalServer
    TestSimple13
    XMLTreePP
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isLinux [
    LinuxInotify2
  ];
  preCheck = ''
    perl certs/create-certs.perl
    export TEST_LEI_ERR_LOUD=1
    export HOME="$NIX_BUILD_TOP"/home
    mkdir -p "$HOME"/.cache/public-inbox/inline-c
  '';

  installTargets = [ "install" ];
  postInstall = ''
    for prog in $out/bin/*; do
<<<<<<< HEAD
        wrapProgram $prog \
            --set NIX_CFLAGS_COMPILE_${stdenv.cc.suffixSalt} -I${lib.getDev libxcrypt}/include \
            --prefix PATH : ${lib.makeBinPath [
              git
              xapian
              /* for InlineC */
              gnumake
              stdenv.cc
            ]}
=======
        wrapProgram $prog --prefix PATH : ${lib.makeBinPath [
          git
          /* for InlineC */
          gnumake
          stdenv.cc.cc
        ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
