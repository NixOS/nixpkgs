{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pcre,
  zlib,
  xz,
}:

stdenv.mkDerivation rec {
  pname = "silver-searcher";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ggreer";
    repo = "the_silver_searcher";
    rev = version;
    sha256 = "0cyazh7a66pgcabijd27xnk1alhsccywivv6yihw378dqxb22i1p";
  };

  patches = [ ./bash-completion.patch ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: src/zfile.o:/build/source/src/log.h:12: multiple definition of
  #     `print_mtx'; src/ignore.o:/build/source/src/log.h:12: first defined here
  # TODO: remove once next release has https://github.com/ggreer/the_silver_searcher/pull/1377
  env.NIX_CFLAGS_COMPILE = "-fcommon";
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    pcre
    zlib
    xz
  ];

  meta = with lib; {
    homepage = "https://github.com/ggreer/the_silver_searcher/";
    description = "A code-searching tool similar to ack, but faster";
    maintainers = with maintainers; [ madjar ];
    mainProgram = "ag";
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
