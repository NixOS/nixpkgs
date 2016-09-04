{ stdenv, lib, fetchurl, zlib, openssl, ncurses, libidn, pcre, libssh, libmysql, postgresql
, withGUI ? false, makeWrapper, pkgconfig, gtk2 }:

let
  makeDirs = output: subDir: pkgs: lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) pkgs);

in stdenv.mkDerivation rec {
  name = "thc-hydra-${version}";
  version = "8.2";

  src = fetchurl {
    url = "http://www.thc.org/releases/hydra-${version}.tar.gz";
    sha256 = "1i2a5glmrxdjr80gfppx6wgakflcpj3ksgng212fjzhxr9m4k24y";
  };

  preConfigure = ''
    substituteInPlace configure \
      --replace "\$LIBDIRS" "${makeDirs "lib" "lib" buildInputs}" \
      --replace "\$INCDIRS" "${makeDirs "dev" "include" buildInputs}" \
      --replace "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
      --replace "libcurses.so" "libncurses.so" \
      --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = lib.optionals withGUI [ pkgconfig makeWrapper ];
  buildInputs = [ zlib openssl ncurses libidn pcre libssh libmysql postgresql ]
                ++ lib.optional withGUI gtk2;

  postInstall = lib.optionalString withGUI ''
    wrapProgram $out/bin/xhydra \
      --add-flags --hydra-path --add-flags "$out/bin/hydra"
  '';

  meta = with stdenv.lib; {
    description = "A very fast network logon cracker which support many different services";
    license = licenses.agpl3;
    homepage = https://www.thc.org/thc-hydra/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
