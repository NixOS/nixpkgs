{ stdenv
, lib
, fetchFromGitHub
, libuuid, curl
, openssl
, pkg-config
, systemd
}:

stdenv.mkDerivation rec {
  pname = "keydb";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "snapchat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-00Dx6GRAXVpJUXhu4kjsVCEsoN615vhGvc7+gViERqI=";
  };

  postPatch = ''
    substituteInPlace deps/lua/src/Makefile \
      --replace "ar rcu" "${stdenv.cc.targetPrefix}ar rcu"
    substituteInPlace src/Makefile \
      --replace "as --64 -g" "${stdenv.cc.targetPrefix}as --64 -g"
  '';

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    (curl.override { inherit openssl; })
    libuuid
    systemd
    openssl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "USE_SYSTEMD=yes"
    "BUILD_TLS=yes"
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "USEASM=${if stdenv.isx86_64 then "true" else "false"}"
  ] ++ lib.optionals (!stdenv.isx86_64) [
    "MALLOC=libc"
  ];

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  meta = with lib; {
    homepage = "https://keydb.dev";
    description = "A Multithreaded Fork of Redis";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ajs124 ];
  };
}
