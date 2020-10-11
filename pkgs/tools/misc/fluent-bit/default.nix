{ stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "v${version}";
    sha256 = "1m8ly2h52mw67kqc7qqpf7sxxnyk4fnw2qavjpj6zgw3i6dhj0p1";
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
