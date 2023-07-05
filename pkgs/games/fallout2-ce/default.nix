{ cmake
, fpattern
, lib
, SDL2
, stdenv
, fetchFromGitHub
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fallout2-ce";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout2-ce";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+N4jhmxBX6z48kaU0jm90OKhguHlggT3OF9uuyY0EV0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL2 zlib ];
  hardeningDisable = [ "format" ];
  cmakeBuildType = "RelWithDebInfo";

  postPatch = ''
    substituteInPlace third_party/fpattern/CMakeLists.txt --replace "FetchContent_Populate" "#FetchContent_Populate"
    substituteInPlace third_party/fpattern/CMakeLists.txt --replace "{fpattern_SOURCE_DIR}" "${fpattern}/include"
    substituteInPlace third_party/fpattern/CMakeLists.txt --replace "$/nix/" "/nix/"
  '';

  installPhase = ''
    runHook preInstall
    install -D fallout2-ce $out/bin/fallout2-ce
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fully working re-implementation of Fallout 2, with the same original gameplay, engine bugfixes, and some quality of life improvements.";
    homepage = "https://github.com/alexbatalov/fallout2-ce";
    license = licenses.sustainableUse;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux;
  };
})
