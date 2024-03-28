{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, cmake
, libtool
, openssl
, pkg-config
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "RedisTimeSeries";
  version = "1.10.10";

  src = fetchFromGitHub {
    owner = "RedisTimeSeries";
    repo = "RedisTimeSeries";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-XarGPmHvht4MUxLHMr0Dm+cCQLABC205xMeGyRI5ZW8=";
  };

  # Neuter getpy3 setup script as it tries too hard to be clever.
  postPatch = ''
    sed -i '2i exit 0' deps/readies/bin/getpy3
    patchShebangs deps/readies/bin
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp bin/*/*.so "$out/lib"

    runHook postInstall
  '';

  strictDeps = true;
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    pkg-config
    python3
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Time Series data structure for Redis";
    homepage = "https://redis.io/docs/data-types/timeseries";
    license = [ licenses.rsal2 licenses.sspl ];
    maintainers = teams.deshaw.members;
    platforms = platforms.linux;
  };
})
