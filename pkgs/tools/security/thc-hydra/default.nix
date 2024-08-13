{
  stdenv,
  lib,
  fetchFromGitHub,
  zlib,
  openssl,
  ncurses,
  libidn,
  pcre,
  libssh,
  libmysqlclient,
  postgresql,
  makeWrapper,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.5";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-hydra";
    rev = "v${version}";
    sha256 = "sha256-gdMxdFrBGVHA1ZBNFW89PBXwACnXTGJ/e/Z5+xVV5F0=";
  };

  postPatch =
    let
      makeDirs =
        output: subDir:
        lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) buildInputs);
    in
    ''
      substituteInPlace configure \
        --replace '$LIBDIRS' "${makeDirs "lib" "lib"}" \
        --replace '$INCDIRS' "${makeDirs "dev" "include"}" \
        --replace "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
        --replace "libcurses.so" "libncurses.so" \
        --replace "-lcurses" "-lncurses"
    '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-undef-prefix";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    zlib
    openssl
    ncurses
    libidn
    pcre
    libssh
    libmysqlclient
    postgresql
    gtk2
  ];

  enableParallelBuilding = true;

  DATADIR = "/share/${pname}";

  postInstall = ''
    wrapProgram $out/bin/xhydra \
      --add-flags --hydra-path --add-flags "$out/bin/hydra"
  '';

  meta = with lib; {
    description = "Very fast network logon cracker which support many different services";
    homepage = "https://github.com/vanhauser-thc/thc-hydra"; # https://www.thc.org/
    changelog = "https://github.com/vanhauser-thc/thc-hydra/raw/v${version}/CHANGES";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
