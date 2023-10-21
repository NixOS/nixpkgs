{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  pname = "core-symbolication";
  version = "unstable-2018-06-17";

  src = fetchFromGitHub {
    repo = "CoreSymbolication";
    owner = "matthewbauer";
    rev = "24c87c23664b3ee05dc7a5a87d647ae476a680e4";
    hash = "sha256-PzvLq94eNhP0+rLwGMKcMzxuD6MlrNI7iT/eV0obtSE=";
  };

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Reverse engineered headers for Apple's CoreSymbolication framework";
    homepage = "https://github.com/matthewbauer/CoreSymbolication";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
