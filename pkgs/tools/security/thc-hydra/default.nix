{ stdenv, lib, fetchFromGitHub, zlib, openssl, ncurses, libidn, pcre, libssh, libmysqlclient, postgresql, samba
, withGUI ? false, makeWrapper, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.5";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-hydra";
    rev = "v${version}";
    sha256 = "sha256-gdMxdFrBGVHA1ZBNFW89PBXwACnXTGJ/e/Z5+xVV5F0=";
  };

  postPatch = let
    makeDirs = output: subDir: lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) buildInputs);
  in ''
    substituteInPlace configure \
      --replace-fail '$LIBDIRS' "${makeDirs "lib" "lib"}" \
      --replace-fail '$INCDIRS' "${makeDirs "dev" "include"}" \
      --replace-fail "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
      --replace-fail "libcurses.so" "libncurses.so" \
      --replace-fail "-lcurses" "-lncurses"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-undef-prefix";

  nativeBuildInputs = lib.optionals withGUI [ pkg-config makeWrapper ];

  buildInputs = [
    zlib openssl ncurses libidn pcre libssh libmysqlclient postgresql
    samba
  ] ++ lib.optional withGUI gtk2;

  enableParallelBuilding = true;

  DATADIR = "/share/${pname}";

  postInstall = lib.optionalString withGUI ''
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
