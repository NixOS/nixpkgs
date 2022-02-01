{ stdenv, lib, fetchFromGitHub, zlib, openssl, ncurses, libidn, pcre, libssh, libmysqlclient, postgresql
, withGUI ? false, makeWrapper, pkg-config, gtk2 }:

stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.2";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = "thc-hydra";
    rev = "v${version}";
    sha256 = "sha256-V9rr5fbJWm0pa+Kp8g95XvLPo/uWcDwyU2goImnIq58=";
  };

  patches = lib.optionals stdenv.isDarwin [
    ./darwin-remove-ldflag.patch
  ];

  postPatch = let
    makeDirs = output: subDir: lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) buildInputs);
  in ''
    substituteInPlace configure \
      --replace '$LIBDIRS' "${makeDirs "lib" "lib"}" \
      --replace '$INCDIRS' "${makeDirs "dev" "include"}" \
      --replace "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
      --replace "libcurses.so" "libncurses.so" \
      --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = lib.optionals withGUI [ pkg-config makeWrapper ];

  buildInputs = [
    zlib openssl ncurses libidn pcre libssh libmysqlclient postgresql
  ] ++ lib.optional withGUI gtk2;

  enableParallelBuilding = true;

  DATADIR = "/share/${pname}";

  postInstall = lib.optionalString withGUI ''
    wrapProgram $out/bin/xhydra \
      --add-flags --hydra-path --add-flags "$out/bin/hydra"
  '';

  meta = with lib; {
    description = "A very fast network logon cracker which support many different services";
    homepage = "https://www.thc.org/thc-hydra/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
