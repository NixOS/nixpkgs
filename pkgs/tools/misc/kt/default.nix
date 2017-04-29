{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "kt-${version}";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "fgeller";
    repo = "kt";
    rev = "v${version}";
    sha256 = "1ymygd3l5pfbnjmdjcrspj520v29hnv3bdgxpim38dpv3qj518vq";
  };

  goPackagePath = "github.com/fgeller/kt";

  meta = with stdenv.lib; {
    description = "Kafka command line tool";
    homepage = https://github.com/fgeller/kt;
    maintainers = with maintainers; [ utdemir ];
    platforms = with platforms; unix;
  };
}
