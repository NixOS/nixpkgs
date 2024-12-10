{
  stdenv,
  lib,
  fetchurl,
}:
let
  pname = "roapi-http";
  version = "0.6.0";
  target = lib.optionalString stdenv.isDarwin "apple-darwin";
in
# TODO build from source, currently compilation fails on darwin on snmalloc with
#  ./mem/../ds/../pal/pal_apple.h:277:64: error: use of undeclared identifier 'kCCSuccess'
#            reinterpret_cast<void*>(&result), sizeof(result)) != kCCSuccess)
#
# rustPlatform.buildRustPackage {
#   pname = "roapi-http";
#   inherit version;

#   src = fetchFromGitHub {
#     owner = "roapi";
#     repo = "roapi";
#     rev = "roapi-http-v${version}";
#     sha256 = "sha256-qHAO3h+TTCQQ7vdd4CoXVGfKZ1fIxTWKqbUNnRsJaok=";
#   };

#   cargoSha256 = "sha256-qDJKC6MXeKerPFwJsNND3WkziFtGkTvCgVEsdPbBGAo=";

#   buildAndTestSubdir = "roapi-http";

#   nativeBuildInputs = [ cmake ];

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/roapi/roapi/releases/download/${pname}-v${version}/${pname}-${target}.tar.gz";
    sha256 = "sha256-lv6BHg/LkrOlyq8D1udAYW8/AbZRb344YCcVnwo3ZHk=";
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    tar xvzf $src
    mkdir -p "$out/bin"
    cp roapi-http $out/bin
  '';

  meta = with lib; {
    description = "Create full-fledged APIs for static datasets without writing a single line of code. ";
    homepage = "https://roapi.github.io/docs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.darwin;
  };
}
