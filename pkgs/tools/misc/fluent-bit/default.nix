{ stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "1x5izsm0b3514i2vl1b3x40chjlzidr5zssn5cpgrw9a8w4jpv6h";
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
