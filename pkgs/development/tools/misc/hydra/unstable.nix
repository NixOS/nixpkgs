{ stdenv
, lib
, nix
, perlPackages
, buildEnv
, makeWrapper
, libtool
, unzip
, pkg-config
, sqlite
, libpqxx
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
, prometheus-cpp
, nukeReferences
, git
, boehmgc
, nlohmann_json
, docbook_xsl
, openssh
, openldap
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
, cacert
, glibcLocales
, fetchFromGitHub
, fetchpatch
, nixosTests
}:

let
  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = with perlPackages; lib.closePropagation
      [
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
        CatalystRuntime
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXScriptServerStarman
        CatalystXRoleApplicator
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DataDump
        DateTime
        DigestSHA1
        EmailMIME
        EmailSender
        FileLibMagic
        FileSlurper
        FileWhich
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
        SQLSplitStatement
        SetScalar
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TermReadKey
        Test2Harness
        TestPostgreSQL
        TestSimple13
        TextDiff
        TextTable
        UUID4Tiny
        XMLSimple
        YAML
        nix.perl-bindings
        git
      ];
  };
in
stdenv.mkDerivation rec {
  pname = "hydra";
  version = "2022-08-08";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "2b1c1e65d5fbbe25625a31ee93cb14c9a9edf969";
    sha256 = "sha256-mjCdJPB4t5OLGZ0r5usJTVs1BBr4cWeGGE7imyUfQnQ=";
  };

  patches = [
    # https://github.com/NixOS/hydra/pull/1215: scmdiff: Hardcode --git-dir
    (fetchpatch {
      url = "https://github.com/NixOS/hydra/commit/b6ea85a601ddac9cb0716d8cb4d446439fa0778f.patch";
      sha256 = "sha256-QHjwLYQucdkBs6OsFI8kWo5ugkPXXlTgdbGFxKBHAHo=";
    })
  ];

  buildInputs =
    [
      libpqxx
      top-git
      mercurial
      darcs
      subversion
      breezy
      openssl
      bzip2
      libxslt
      nix
      perlDeps
      perl
      pixz
      boost
      postgresql
      nlohmann_json
      prometheus-cpp
    ];

  hydraPath = lib.makeBinPath (
    [
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
      mercurial
      darcs
      gnused
      breezy
    ] ++ lib.optionals stdenv.isLinux [ rpm dpkg cdrkit ]
  );

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
    mdbook
    unzip
    nukeReferences
  ];

  checkInputs = [
    cacert
    foreman
    glibcLocales
    python3
    libressl.nc
    openldap
  ];

  configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

  NIX_CFLAGS_COMPILE = "-pthread";

  OPENLDAP_ROOT = openldap;

  shellHook = ''
    PATH=$(pwd)/src/script:$(pwd)/src/hydra-eval-jobs:$(pwd)/src/hydra-queue-runner:$(pwd)/src/hydra-evaluator:$PATH
    PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
  '';

  enableParallelBuilding = true;

  postPatch = ''
    # Change 5s timeout for init to 30s
    substituteInPlace t/lib/HydraTestContext.pm \
      --replace 'expectOkay(5, ("hydra-init"));' 'expectOkay(30, ("hydra-init"));'
  '';

  preCheck = ''
    patchShebangs .
    export LOGNAME=''${LOGNAME:-foo}
    # set $HOME for bzr so it can create its trace file
    export HOME=$(mktemp -d)
    # remove flaky test
    rm t/Hydra/Controller/User/ldap-legacy.t
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
  '';

  dontStrip = true;

  doCheck = true;

  passthru = {
    inherit nix perlDeps;
    tests.basic = nixosTests.hydra.hydra_unstable;
  };

  meta = with lib; {
    description = "Nix-based continuous build system";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lheckemann mindavi das_j ];
  };
}
