{ stdenv, nixUnstable, perlPackages, buildEnv, releaseTools, fetchFromGitHub
, makeWrapper, autoconf, automake, libtool, unzip, pkgconfig, sqlite, libpqxx
, gitAndTools, mercurial, darcs, subversion, bazaar, openssl, bzip2, libxslt
, guile, perl, postgresql92, aws-sdk-cpp, nukeReferences, git, boehmgc
, docbook_xsl, openssh, gnused, coreutils, findutils, gzip, lzma, gnutar
, rpm, dpkg, cdrkit, fetchpatch }:

with stdenv;

let
  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = with perlPackages;
      [ ModulePluggable
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystDevel
        CatalystDispatchTypeRegex
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystPluginUnicodeEncoding
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXScriptServerStarman
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DataDump
        DateTime
        DigestSHA1
        EmailMIME
        EmailSender
        FileSlurp
        IOCompress
        IPCRun
        JSONXS
        LWP
        LWPProtocolHttps
        NetAmazonS3
        NetStatsd
        PadWalker
        Readonly
        SQLSplitStatement
        SetScalar
        Starman
        SysHostnameLong
        TestMore
        TextDiff
        TextTable
        XMLSimple
        nixUnstable
        git
        boehmgc
      ];
  };
in releaseTools.nixBuild rec {
  name = "hydra-${version}";
  version = "2016-04-15";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "hydra";
    rev = "177bf25d648092826a75369191503a3f2bb763a4";
    sha256 = "0ngipzm2i2vz5ygfd70hh82d027snpl85r8ncn1rxlkak0g8fxsl";
  };

  patches = [(fetchpatch {
    name = "cmath.diff";
    url = https://github.com/vcunat/hydra/commit/3c6fca1ba299.diff; # https://github.com/NixOS/hydra/pull/337
    sha256 = "02m9q304ay45s7xfkm2y7lppakrkx3hrq39mm6348isnbqmbarc0";
  })];

  buildInputs =
    [ makeWrapper autoconf automake libtool unzip nukeReferences pkgconfig sqlite libpqxx
      gitAndTools.topGit mercurial darcs subversion bazaar openssl bzip2 libxslt
      guile # optional, for Guile + Guix support
      perlDeps perl nixUnstable
      postgresql92 # for running the tests
      (lib.overrideDerivation (aws-sdk-cpp.override {
        apis = ["s3"];
        customMemoryManagement = false;
      }) (attrs: {
        src = fetchFromGitHub {
          owner = "edolstra";
          repo = "aws-sdk-cpp";
          rev = "local";
          sha256 = "1vhgsxkhpai9a7dk38q4r239l6dsz2jvl8hii24c194lsga3g84h";
        };
      }))
    ];

  hydraPath = lib.makeBinPath (
    [ libxslt sqlite subversion openssh nixUnstable coreutils findutils
      gzip bzip2 lzma gnutar unzip git gitAndTools.topGit mercurial darcs gnused bazaar
    ] ++ lib.optionals stdenv.isLinux [ rpm dpkg cdrkit ] );

  postUnpack = ''
    # Clean up when building from a working tree.
    (cd $sourceRoot && (git ls-files -o --directory | xargs -r rm -rfv)) || true
  '';

  configureFlags = [ "--with-docbook-xsl=${docbook_xsl}/xml/xsl/docbook" ];

  preHook = ''
    PATH=$(pwd)/src/script:$(pwd)/src/hydra-eval-jobs:$(pwd)/src/hydra-queue-runner:$PATH
    PERL5LIB=$(pwd)/src/lib:$PERL5LIB;
  '';

  preConfigure = "autoreconf -vfi";

  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs .
    export LOGNAME=''${LOGNAME:-foo}
  '';

  postInstall = ''
    mkdir -p $out/nix-support
    for i in $out/bin/*; do
        read -n 4 chars < $i
        if [[ $chars =~ ELF ]]; then continue; fi
        wrapProgram $i \
            --prefix PERL5LIB ':' $out/libexec/hydra/lib:$PERL5LIB \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set HYDRA_RELEASE ${version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nixUnstable.name or "unknown"}
    done
  ''; # */

  dontStrip = true;

  passthru.perlDeps = perlDeps;

  meta = with stdenv.lib; {
    description = "Nix-based continuous build system";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ domenkozar ];
  };
 }
