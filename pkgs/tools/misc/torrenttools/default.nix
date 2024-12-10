{
  lib,
  stdenv,
  fetchFromGitHub,
  bencode,
  catch2,
  cli11,
  cmake,
  ctre,
  expected-lite,
  fmt,
  gsl-lite,
  howard-hinnant-date,
  yaml-cpp,
  ninja,
  nlohmann_json,
  openssl,
  re2,
  sigslot,
}:

stdenv.mkDerivation rec {
  pname = "torrenttools";
  version = "0.6.2";

  srcs = [
    (fetchFromGitHub rec {
      owner = "fbdtemme";
      repo = "torrenttools";
      rev = "v${version}";
      hash = "sha256-3rAxw4JM5ruOn0ccKnpdCnUWUPTQOUvRYz8OKU/FpJ8=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "fbdtemme";
      repo = "cliprogress";
      rev = "a887519e360e44c1ef88ea4ef7df652ea049c502";
      hash = "sha256-nVvzez5GB57qSj2SLaxdYlkSX8rRM06H2NnLQGCDWMg=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "fbdtemme";
      repo = "dottorrent";
      rev = "38ac810d6bb3628fd3ce49150c9fb641bb5e78cd";
      hash = "sha256-0H9h0Hud0Fd64lY0pxQ96coDOEDr5wh8v1sNT1lBxb0=";
      name = repo;
    })
    (fetchFromGitHub rec {
      owner = "fbdtemme";
      repo = "termcontrol";
      rev = "c53eec4efe0e163871d9eb54dc074c25cd01abf0";
      hash = "sha256-0j78QtEkhlssVivPl709o5Pf36TzhOZ6VHaqDiH0L0I=";
      name = repo;
    })
  ];
  sourceRoot = "torrenttools";

  postUnpack = ''
    cp -pr cliprogress torrenttools/external/cliprogress
    cp -pr dottorrent torrenttools/external/dottorrent
    cp -pr termcontrol torrenttools/external/termcontrol
    chmod -R u+w -- "$sourceRoot"
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    bencode
    catch2
    cli11
    ctre
    expected-lite
    fmt
    gsl-lite
    howard-hinnant-date
    yaml-cpp
    nlohmann_json
    openssl
    re2
    sigslot
  ];

  cmakeFlags = [
    "-DTORRENTTOOLS_BUILD_TESTS:BOOL=ON"
    "-DTORRENTTOOLS_TBB:BOOL=OFF" # Our TBB doesn't expose a CMake module.
  ];

  doCheck = true;

  meta = with lib; {
    description = "A CLI tool for creating, inspecting and modifying BitTorrent metafiles";
    homepage = "https://github.com/fbdtemme/torrenttools";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
    mainProgram = "torrenttools";
  };
}
