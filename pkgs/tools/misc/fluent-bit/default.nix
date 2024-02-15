{ lib
, stdenv
, fetchFromGitHub
, cmake
, flex
, bison
, systemd
, postgresql
, openssl
, libyaml
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluent-bit";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+AkIoGIAwz5dqQGtTJQjz+a9jgtxU1zwDuivj862Rw0=";
  };

  nativeBuildInputs = [ cmake flex bison ];

  buildInputs = [ openssl libyaml postgresql ]
    ++ lib.optionals stdenv.isLinux [ systemd ];

  cmakeFlags = [
    "-DFLB_RELEASE=ON"
    "-DFLB_METRICS=ON"
    "-DFLB_HTTP_SERVER=ON"
    "-DFLB_OUT_PGSQL=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    # Used by the embedded luajit, but is not predefined on older mac SDKs.
    lib.optionals stdenv.isDarwin [ "-DTARGET_OS_IPHONE=0" ]
    # Assumes GNU version of strerror_r, and the posix version has an
    # incompatible return type.
    ++ lib.optionals (!stdenv.hostPlatform.isGnu) [ "-Wno-int-conversion" ]
  );

  outputs = [ "out" "dev" ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace /lib/systemd $out/lib/systemd
  '';

  meta = {
    changelog = "https://github.com/fluent/fluent-bit/releases/tag/v${finalAttrs.version}";
    description = "Log forwarder and processor, part of Fluentd ecosystem";
    homepage = "https://fluentbit.io";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.samrose lib.maintainers.fpletz ];
    platforms = lib.platforms.unix;
  };
})
