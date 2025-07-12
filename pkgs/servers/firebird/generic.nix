{
  version,
  hash,
  rev ? "v${version}",
  buildInputs ? [ ],
}:

(
  {
    lib,
    stdenv,
    fetchFromGitHub,
    autoreconfHook,
    icu,
    libedit,
    libtomcrypt,
    libtommath,
    unzip,
    zlib,
    superServer ? false,
  }:

  let
    extraBuildInputs = [
      libtomcrypt
    ];
    isVersion = v: (lib.versions.major version) == v;
  in
  stdenv.mkDerivation {
    pname = "firebird";
    inherit version;

    src = fetchFromGitHub {
      owner = "FirebirdSQL";
      repo = "firebird";
      inherit hash;
      rev = "v${version}";
    };

    nativeBuildInputs = [ autoreconfHook ];
    buildInputs = [
      libedit
      icu
      libtommath
      zlib
    ] ++ lib.optionals (isVersion "4") extraBuildInputs;

    LD_LIBRARY_PATH = lib.makeLibraryPath [ icu ];
    #postInstall = ''
    #  wrapProgram "$out/gen/Release/firebird/bin/isql"
    #''

    configureFlags =
      [
        "--with-system-editline"
      ]
      ++ lib.optional (!isVersion "3") "--with-system-icu"
      ++ (lib.optional superServer "--enable-superserver");

    #enableParallelBuilding = false;

    installTargets = [ "buildTarDir" ];
    installFlags = [ "-C gen -f Makefile.install" ];

    #installPhase = ''
    #  runHook preInstall

    #  cd gen/Release/firebird/

    #  rm firebird.log
    #  rm bin/*.sh
    #  rm -rf examples/

    #  mkdir -p "$out/bin"
    #  # bin
    #  mv bin/gbak "$out/bin"
    #  mv bin/gfix "$out/bin"
    #  mv bin/gpre "$out/bin"
    #  mv bin/gsec "$out/bin"
    #  mv bin/nbackukp "$out/bin"
    #  mv bin/gsplit "$out/bin"
    #  mv bin/gstat "$out/bin"
    #  mv bin/fbsvcmgr "$out/bin"
    #  mv bin/fbtracemgr "$out/bin"
    #  mv bin/isql "$out/bin"
    #  mv bin/qli "$out/bin"
    #  # sbin
    #  mv bin/firebird "$out/bin"
    #  mv bin/fbguard "$out/bin"
    #  mv bin/fb_lock_print "$out/bin"

    #  mkdir -p "$out"
    #  mv * "$out"

    #  runHook postInstall
    #'';

    meta = {
      description = "SQL relational database management system";
      downloadPage = "https://github.com/FirebirdSQL/firebird/";
      homepage = "https://firebirdsql.org/";
      changelog = "https://github.com/FirebirdSQL/firebird/blob/master/CHANGELOG.md";
      license = [
        "IDPL"
        "Interbase-1.0"
      ];
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        bbenno
        marcweber
      ];
    };
  }
)
