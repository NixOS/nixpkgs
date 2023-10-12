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
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6uq5eOHx0P2S3WsN0PooNlGQS2ty7DdPsCEgoQsLmRM=";
  };

  nativeBuildInputs = [ cmake flex bison ];

  buildInputs = [ openssl libyaml postgresql ]
    ++ lib.optionals stdenv.isLinux [ systemd ];

  cmakeFlags = [ "-DFLB_METRICS=ON" "-DFLB_HTTP_SERVER=ON" "-DFLB_OUT_PGSQL=ON"  ];

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isGNU [ "-O" ]
    # Workaround build failure on -fno-common toolchains:
    #   ld: /monkey/mk_tls.h:81: multiple definition of `mk_tls_server_timeout';
    #     flb_config.c.o:include/monkey/mk_tls.h:81: first defined here
    # TODO: drop when upstream gets a fix for it:
    #   https://github.com/fluent/fluent-bit/issues/5537
    ++ lib.optionals stdenv.isDarwin [ "-fcommon" ]);

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
    platforms = lib.platforms.linux;
  };
})
