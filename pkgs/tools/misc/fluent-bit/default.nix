{ stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "0qxyjmgl85q7xk629l548bpzizma5n4j1r6nqbwh9j15ajvq7mq8";
  };

  nativeBuildInputs = [ cmake flex bison ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace /lib/systemd $out/lib/systemd
  '';

  meta = with stdenv.lib; {
    description = "Log forwarder and processor, part of Fluentd ecosystem";
    homepage = "https://fluentbit.io";
    maintainers = with maintainers; [
      samrose
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
