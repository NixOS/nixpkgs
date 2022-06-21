{ lib, fetchFromGitHub }:
rec {
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "woodpecker-ci";
    repo = "woodpecker";
    rev = "v${version}";
    sha256 = "sha256-HOOH3H2SXLcT2oW/xL80TO+ZSI+Haulnznpb4hlCQow=";
  };

  meta = with lib; {
    homepage = "https://woodpecker-ci.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
  };
}
