{ stdenv
, lib
, nix
, perlPackages
, buildEnv
, makeWrapper
, unzip
, pkg-config
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
, fetchpatch2
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
  version = "2023-12-04";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "4dc8fe0b08edc421c251270ccd4be3e5bf9d66b4";
    hash = "sha256-FjyMb5ZbPa2GLrRuFMUP/foKb0KvXFKThvgc9faFIw8=";
  };

  patches = [
    # hydra-eval-jobs: don't use restrict-eval for Flakes
    # https://github.com/NixOS/hydra/pull/1257
    # should be removed when https://github.com/NixOS/nix/pull/9547
    # lands in the nix version used by hydra
    (fetchpatch2 {
      url = "https://github.com/NixOS/hydra/commit/9370b0ef977bff7e84ac07a81a0e31e75989276b.patch";
      hash = "sha256-BRenC0lpWPgzfx42MPJBQ9VBamh5hZXuuVe6TXYKkdE=";
    })
  ];

  buildInputs = [
    unzip
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
    nukeReferences
  ];

  nativeCheckInputs = [
    cacert
    foreman
    glibcLocales
    python3
    libressl.nc
    openldap
  ];

  configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

  env.NIX_CFLAGS_COMPILE = "-pthread";

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
    homepage = "https://nixos.org/hydra";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lheckemann mindavi ] ++ teams.helsinki-systems.members;
  };
}
