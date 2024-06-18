{ stdenv, lib, fetchFromGitHub, glib, readline
, bison, flex, pkg-config, autoreconfHook
, txt2man, which
}:

stdenv.mkDerivation rec {
  pname = "mdbtools";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mdbtools";
    repo = "mdbtools";
    rev = "v${version}";
    sha256 = "sha256-e9rgTWu8cwuccpp/wAfas1ZeQPTpGcgE6YjLz7KRnhw=";
  };

  configureFlags = [ "--disable-scrollkeeper" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=unused-but-set-variable";

  nativeBuildInputs = [
    pkg-config bison flex autoreconfHook txt2man which
  ];

  buildInputs = [ glib readline ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = ".mdb (MS Access) format tools";
    license = with licenses; [ gpl2Plus lgpl2 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
