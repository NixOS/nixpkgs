{
  lib,
  stdenv,
  fetchFromGitHub,

  # build inputs
  cacert,
  libuuid,

  # build inputs (darwin)
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "premake5";
  version = "5.0.0-beta4";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sNLCyIHWDW/8jIrMFCZAqtWsh4SRugqtPR4HaoW/Vzk=";
  };

  buildInputs = [
    libuuid
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    readline
  ];

  patches = [ ./no-curl-ca.patch ];
  postPatch = ''
    substituteInPlace contrib/curl/premake5.lua \
      --replace-fail "ca = nil" "ca = '${cacert}/etc/ssl/certs/ca-bundle.crt'"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace premake5.lua \
      --replace-fail '"-arch arm64"' '""' \
      --replace-fail '"-arch x86_64"' '""'
  ''
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace \
      binmodules/example/premake5.lua \
      binmodules/luasocket/premake5.lua \
      --replace-fail SharedLib StaticLib
  '';

  buildPhase =
    if stdenv.hostPlatform.isDarwin then
      # Error compiling the builtin zlib source, but it's not used currently
      ''
        make PREMAKE_OPTS="--zlib-src=none" \
             PLATFORM="Universal" \
             -f Bootstrap.mak osx
      ''
    else
      ''
        make PLATFORM=${stdenv.hostPlatform.linuxArch} \
          -f Bootstrap.mak linux
      '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://premake.github.io";
    description = "Simple build configuration and project generation tool using lua";
    mainProgram = "premake5";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sarahec ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
