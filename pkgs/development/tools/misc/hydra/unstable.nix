{ stdenv
, lib
, nix
, perlPackages
, buildEnv
, fetchFromGitHub
, fetchpatch
, makeWrapper
, nixosTests
, autoconf
, automake
, cacert
, glibcLocales
, libtool
, unzip
, pkg-config
, sqlite
, libpqxx_6
, top-git
, mercurial
, darcs
, subversion
, breezy
, openssl
, bzip2
, libxslt
, perl
, postgresql
, nukeReferences
, git
, boehmgc
, nlohmann_json
, docbook_xsl
, openssh
, gnused
, coreutils
, findutils
, gzip
, xz
, gnutar
, rpm
, dpkg
, cdrkit
, pixz
, boost
, autoreconfHook
, mdbook
, foreman
, python3
, libressl
}:

  let
    perlDeps = buildEnv {
      name = "hydra-perl-deps";
      paths = with perlPackages; lib.closePropagation [
        AuthenSASL
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystAuthenticationStoreLDAP
        CatalystDevel
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginPrometheusTiny
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystPluginUnicodeEncoding
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXRoleApplicator
        CatalystXScriptServerStarman
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DataDump
        DateTime
        DBDPg
        DBDSQLite
        DigestSHA1
        EmailMIME
        EmailSender
        FileSlurper
        FileWhich
        git
        IOCompress
        IPCRun
        IPCRun3
        JSON
        JSONMaybeXS
        JSONXS
        ListSomeUtils
        LWP
        LWPProtocolHttps
        ModulePluggable
        NetAmazonS3
        NetPrometheus
        NetStatsd
        PadWalker
        ParallelForkManager
        PerlCriticCommunity
        PrometheusTinyShared
        ReadonlyX
        SetScalar
        SQLSplitStatement
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TermReadKey
        Test2Harness
        TestMore
        TestPostgreSQL
        TextDiff
        TextTable
        UUID4Tiny
        YAML
        XMLSimple
        nix.perl-bindings
      ];
    };
  in
  stdenv.mkDerivation rec {
    pname = "hydra";

    version = "2022-02-07";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "hydra";
      rev = "517dce285a851efd732affc084c7083aed2e98cd";
      sha256 = "sha256-abWhd/VLNse3Gz7gcVbFANJLAhHV4nbOKjhVDmq/Zmg=";
    };

    buildInputs = [
      makeWrapper
      autoconf
      automake
      libtool
      unzip
      nukeReferences
      sqlite
      libpqxx_6
      top-git
      mercurial
      darcs
      subversion
      breezy
      openssl
      bzip2
      libxslt
      perlDeps
      perl
      nix
      postgresql # for running the tests
      nlohmann_json
      boost
      pixz
    ];

    hydraPath = lib.makeBinPath ([
      sqlite
      subversion
      openssh
      nix
      coreutils
      findutils
      pixz
      gzip
      bzip2
      xz
      gnutar
      unzip
      git
      top-git
      mercurial /*darcs*/
      gnused
      breezy
    ] ++ lib.optionals stdenv.isLinux [ rpm dpkg cdrkit ]);

    nativeBuildInputs = [ autoreconfHook pkg-config mdbook ];

    configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

    checkInputs = [
      cacert
      foreman
      glibcLocales
      python3
      libressl.nc
    ];

    NIX_CFLAGS_COMPILE = "-pthread";

    shellHook = ''
      PATH=$(pwd)/src/script:$(pwd)/src/hydra-eval-jobs:$(pwd)/src/hydra-queue-runner:$(pwd)/src/hydra-evaluator:$PATH
      PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
    '';

    enableParallelBuilding = true;

    preCheck = ''
      patchShebangs .
      export LOGNAME=''${LOGNAME:-foo}
      # set $HOME for bzr so it can create its trace file
      export HOME=$(mktemp -d)
    '';

    postInstall = ''
      mkdir -p $out/nix-support
      for i in $out/bin/*; do
          read -n 4 chars < $i
          if [[ $chars =~ ELF ]]; then continue; fi
          wrapProgram $i \
              --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
              --prefix PATH ':' $out/bin:$hydraPath \
              --set-default HYDRA_RELEASE ${version} \
              --set HYDRA_HOME $out/libexec/hydra \
              --set NIX_RELEASE ${nix.name or "unknown"}
      done
    ''; # */

    dontStrip = true;

    doCheck = true;

    passthru = {
      inherit perlDeps;
      tests.basic = nixosTests.hydra.hydra-unstable;
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/NixOS/hydra/commit/5ae26aa7604f714dcc73edcb74fe71ddc8957f6c.patch";
        sha256 = "sha256-wkbWo8SFbT3qwVxwkKQWpQT5Jgb1Bb51yiLTlFdDN/I=";
      })
    ];

    meta = with lib; {
      description = "Nix-based continuous build system";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ lheckemann mindavi das_j ];
    };
  }
