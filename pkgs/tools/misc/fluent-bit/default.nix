{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, flex, bison, systemd, openssl }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.8.11";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "sha256-DULXfkddBdCvTWkuWXjSTEujRZ3mVVzy//qeB3j0Vz8=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # Fix compilations errors on darwin
    (fetchpatch {
      url = "https://github.com/calyptia/cmetrics/commit/4f0f7ae2eeec148a69156f9fcc05d64bf249d11e.patch";
      sha256 = "sha256-M1+28mHxpMvcFkOoKxkMMo1VCQsG33ncFZkFalOq2FQ=";
      stripLen = 1;
      extraPrefix = "lib/cmetrics/";
    })
    (fetchpatch {
      url = "https://github.com/calyptia/cmetrics/commit/a97999cb6d7299ef230d216b7a1c584b43c64de9.patch";
      sha256 = "sha256-RuyPEeILc86n/klPIb334XpX0F71nskQ8s/ya0rE2zI=";
      stripLen = 1;
      extraPrefix = "lib/cmetrics/";
    })

    # Fix bundled luajit compilation args
    ./fix-luajit-darwin.patch
  ];

  nativeBuildInputs = [ cmake flex bison ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ];

  cmakeFlags = [ "-DFLB_METRICS=ON" "-DFLB_HTTP_SERVER=ON" ];

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-O";

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
