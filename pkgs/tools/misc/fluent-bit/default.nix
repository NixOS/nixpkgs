{ lib, stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "sha256-a3AVem+VbYKUsxAzGNu/VPqDiqG99bmj9p1/iiG1ZFw=";
  };

  nativeBuildInputs = [ cmake flex bison ];

  patches = lib.optionals stdenv.isDarwin [ ./fix-luajit-darwin.patch ];

  # _FORTIFY_SOURCE requires compiling with optimization (-O)
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-O";

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace /lib/systemd $out/lib/systemd
  '';

  meta = with lib; {
    description = "Log forwarder and processor, part of Fluentd ecosystem";
    homepage = "https://fluentbit.io";
    maintainers = with maintainers; [
      samrose
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
