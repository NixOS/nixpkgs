{ stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "07p0cy4y2x45kgimg7rjjk9zknmnnsfxdy2vlz6dzaxrslv6c3x6";
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
