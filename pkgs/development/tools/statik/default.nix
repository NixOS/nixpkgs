{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "statik";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "statik";
    rev = "v${version}";
    sha256 = "1xrmzm8vl075ssp2x0wbmzs2wsp429q6yblww4nmbyg700wc5hah";
  };

  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/rakyll/statik";
    description = "Embed files into a Go executable ";
    license = licenses.asl20;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
