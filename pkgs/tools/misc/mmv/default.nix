{ lib, stdenv, fetchFromGitHub, pkg-config, gengetopt, m4, gnupg
, git, perl, autoconf, automake, help2man }:

stdenv.mkDerivation rec {
  pname = "mmv";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "mmv";
    rev = "v${version}";
    hash = "sha256-uiRKdkBLr3ZSovIqso/F85cfoSrymZpyzGa63wp5XnY=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    ./bootstrap
  '';

  nativeBuildInputs = [ gengetopt m4 git gnupg perl autoconf automake help2man pkg-config ];

  enableParallelBuilding = true;

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
      "-Wno-error=int-conversion"
    ];
  };

  meta = {
    homepage = "https://github.com/rrthomas/mmv";
    description = "Utility for wildcard renaming, copying, etc";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
