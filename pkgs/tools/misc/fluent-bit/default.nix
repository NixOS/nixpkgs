{ lib, stdenv, fetchFromGitHub, cmake, flex, bison, systemd, openssl }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "sha256-CMkVIWaD4Zt6SJ/4PLGrFDhirqeLbXcVa+96wsAYN/k=";
  };

  nativeBuildInputs = [ cmake flex bison ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ];

  cmakeFlags = [ "-DFLB_METRICS=ON" "-DFLB_HTTP_SERVER=ON" ];

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-O" ]
    # Workaround build failure on -fno-common toolchains:
    #   ld: /monkey/mk_tls.h:81: multiple definition of `mk_tls_server_timeout';
    #     flb_config.c.o:include/monkey/mk_tls.h:81: first defined here
    # TODO: drop when upstream gets a fix for it:
    #   https://github.com/fluent/fluent-bit/issues/5537
    ++ lib.optionals stdenv.isDarwin [ "-fcommon" ];

  outputs = [ "out" "dev" ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace /lib/systemd $out/lib/systemd
  '';

  meta = with lib; {
    description = "Log forwarder and processor, part of Fluentd ecosystem";
    homepage = "https://fluentbit.io";
    maintainers = with maintainers; [ samrose fpletz ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
