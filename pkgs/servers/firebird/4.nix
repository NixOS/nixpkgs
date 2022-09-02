{ autoreconfHook
, fetchFromGitHub
, icu
, lib
, libedit
, libtomcrypt
, libtommath
, stdenv
, unzip
, zlib

, superServer ? false
}:

stdenv.mkDerivation rec {
  pname = "firebird";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "FirebirdSQL";
    repo = "firebird";
    rev = "v${version}";
    sha256 = "sha256-hddW/cozboGw693q4k5f4+x9ccQFWFytXPUaBVkFnL4=";
  };

  configureFlags = [
    "--with-system-editline"
  ] ++ lib.optional superServer "--enable-superserver";

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    unzip
  ];

  buildInputs = [
    icu
    libedit
    libtomcrypt
    libtommath
    zlib
  ];

  preBuild = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ icu ]}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r gen/Release/firebird/* $out

    mkdir -p $client/lib/
    cp -r gen/Release/firebird/lib/libfbclient.so* $client/lib/

    runHook postInstall
  '';

  outputs = [ "out" "client" ];

  meta = with lib; {
    description = "SQL relational database management system";
    changelog = "https://github.com/FirebirdSQL/firebird/blob/v${version}/CHANGELOG.md";
    downloadPage = "https://github.com/FirebirdSQL/firebird/";
    homepage = "https://firebirdsql.org/";
    license = [
      "IDPL-1.0" # https://www.firebirdsql.org/en/initial-developer-s-public-license-version-1-0/
      "Interbase-1.0" # https://www.firebirdsql.org/en/interbase-public-license/
    ];
    maintainers = with maintainers; [ marcweber superherointj ];
    platforms = platforms.linux;
    # broken = true; # 2022-09-11:
                     # Firebird server is not properly packaged, and is broken.
                     # Firebird client lib is fine and is required downstream, blocking from enabling broken.
  };
}
