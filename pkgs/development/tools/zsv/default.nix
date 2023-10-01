{ lib, stdenv, fetchFromGitHub, perl, jq }:

stdenv.mkDerivation rec {
  pname = "zsv";
  version = "0.3.7-alpha";

  src = fetchFromGitHub {
    owner = "liquidaty";
    repo = "zsv";
    rev = "v${version}";
    hash = "sha256-1eyGy6StFKFisyxTV9EuAwV1ZhuGnN0/STwVo/xmXNw=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ jq ];

  configureFlags = [
    "--jq-prefix=${jq.lib}"
  ];

  meta = with lib; {
    description = "World's fastest (simd) CSV parser, with an extensible CLI";
    homepage = "https://github.com/liquidaty/zsv";
    changelog = "https://github.com/liquidaty/zsv/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
    platforms = platforms.all;
  };
}
