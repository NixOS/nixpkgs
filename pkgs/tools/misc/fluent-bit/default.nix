{ lib, stdenv, fetchFromGitHub, cmake, flex, bison, systemd }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.8.9";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "sha256-b+MZuZQB/sl0HcioU1KCxH3TNiXYSPBfC9dBKqCVeXk=";
  };

  nativeBuildInputs = [ cmake flex bison ];

  buildInputs = lib.optionals stdenv.isLinux [ systemd ];

  cmakeFlags = [ "-DFLB_METRICS=ON" "-DFLB_HTTP_SERVER=ON" ];

  patches = lib.optionals stdenv.isDarwin [ ./fix-luajit-darwin.patch ];

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
