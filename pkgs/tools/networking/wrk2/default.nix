{
  lib,
  stdenv,
  fetchFromGitHub,
  luajit,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "wrk2";
  version = "4.0.0-${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "giltene";
    repo = "wrk2";
    rev = "e0109df5b9de09251adb5f5848f223fbee2aa9f5";
    sha256 = "1aqdwmgdd74wq73f1zp28yqj91gd6p6nf9nbdfibl7mlklbzvak8";
  };

  buildInputs = [
    luajit
    openssl
    zlib
  ];

  patchPhase = ''
    rm -rf deps/luajit && mkdir deps/luajit

    substituteInPlace ./Makefile \
      --replace '-lluajit' '-lluajit-5.1' \
      --replace '_BSD_SOURCE' '_DEFAULT_SOURCE' \
      --replace 'cd $(LDIR) && ./luajit' '${luajit}/bin/luajit' \
      --replace 'config.h Makefile $(LDIR)/libluajit.a' 'config.h Makefile'

    substituteInPlace ./src/script.c \
      --replace 'struct luaL_reg ' 'struct luaL_Reg '
  '';

  dontConfigure = true;
  installPhase = ''
    mkdir -p $out/bin
    mv ./wrk $out/bin/wrk2
  '';

  meta = {
    description = "Constant throughput, correct latency recording variant of wrk";
    homepage = "https://github.com/giltene/wrk2";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
    mainProgram = "wrk2";
  };
}
