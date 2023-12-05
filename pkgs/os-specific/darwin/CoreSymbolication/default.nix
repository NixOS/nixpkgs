{ lib, fetchFromGitHub, fetchpatch, stdenv }:

stdenv.mkDerivation {
  pname = "core-symbolication";
  version = "unstable-2018-06-17";

  src = fetchFromGitHub {
    repo = "CoreSymbolication";
    owner = "matthewbauer";
    rev = "24c87c23664b3ee05dc7a5a87d647ae476a680e4";
    hash = "sha256-PzvLq94eNhP0+rLwGMKcMzxuD6MlrNI7iT/eV0obtSE=";
  };

  patches = [
    # C99 compilation fix
    # https://github.com/matthewbauer/CoreSymbolication/pull/1
    (fetchpatch {
      url = "https://github.com/boltzmannrain/CoreSymbolication/commit/1c26cc93f260bda9230a93e91585284e80aa231f.patch";
      hash = "sha256-d/ieDEnvZ9kVOjBVUdJzGmdvC1AF3Jk4fbwp04Q6l/I=";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" ];

  meta = with lib; {
    description = "Reverse engineered headers for Apple's CoreSymbolication framework";
    homepage = "https://github.com/matthewbauer/CoreSymbolication";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
