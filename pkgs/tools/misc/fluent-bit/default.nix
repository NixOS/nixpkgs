{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation {
  pname = "fluent-bit";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    rev = "8cc3a1887c3fcd6dd95a4a475fb213a0e399c222";
    sha256 = "0rmdbrhhrim80d0hwbz56d5f8rypm6h62ks3xnr0b4w987w10653";
  };

  nativeBuildInputs = [ cmake ];

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
