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
, firebird

, superServer ? false
}:

stdenv.mkDerivation rec {
  pname = "firebird";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "FirebirdSQL";
    repo = "firebird";
    rev = "v${version}";
    sha256 = "sha256-PT2b3989n/7xLGNREWinEey9SGnAXShITdum+yiFlHY=";
  };

  configureFlags = [
    "--with-system-editline"
  ] ++ lib.optional superServer "--enable-superserver";

  enableParallelBuilding = true;

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    icu
    libedit
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
    runHook postInstall
  '';

  meta = firebird.meta // {
    hydraPlatforms = [];
    platforms = [ "x86_64-linux" ];
    broken = true; # 2022-09-11
  };
}
