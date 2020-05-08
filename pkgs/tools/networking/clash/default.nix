{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nb4hl9x2lj0hy8byz14c2xn6yhrb6pqmhzl002k83qd3zrc6s3p";
  };

  goPackagePath = "github.com/Dreamacro/clash";
  modSha256 = "113ynl1f01ihmbc376rb421rrjlxxbc8p9fhxrvpxcsm10rjky8w";

  buildFlagsArray = [
    "-ldflags="
    "-X ${goPackagePath}/constant.Version=${version}"
  ];

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun filalex77 ];
    platforms = platforms.all;
  };
}
