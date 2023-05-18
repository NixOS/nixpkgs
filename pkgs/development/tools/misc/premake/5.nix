{ lib, stdenv, fetchFromGitHub, libuuid, cacert, Foundation, readline }:

stdenv.mkDerivation rec {
  pname = "premake5";
  version = "5.0.0-beta2";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${version}";
    sha256 = "sha256-2R5gq4jaQsp8Ny1oGuIYkef0kn2UG9jMf20vq0714oY=";
  };

  buildInputs = [ libuuid ] ++ lib.optionals stdenv.isDarwin [ Foundation readline ];

  patches = [ ./no-curl-ca.patch ];
  patchPhase = ''
    substituteInPlace contrib/curl/premake5.lua \
      --replace "ca = nil" "ca = '${cacert}/etc/ssl/certs/ca-bundle.crt'"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace premake5.lua \
      --replace -mmacosx-version-min=10.4 -mmacosx-version-min=10.5
  '';

  buildPhase =
    if stdenv.isDarwin then ''
       make -f Bootstrap.mak osx
    '' else ''
       make -f Bootstrap.mak linux
    '';

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "https://premake.github.io";
    description = "A simple build configuration and project generation tool using lua";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
