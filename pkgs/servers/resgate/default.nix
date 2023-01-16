{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "resgate";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "resgateio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CAK2BjHa/l4cAWUKL0hGjqKi/Cdg+/K/MlnDreB69YE=";
  };

  vendorHash = "sha256-6uLCZvvQ8lRug6TlavQ1t73RqJlLCRxTwUhMp3OMMB0=";

  meta = with lib; {
    description = "A Realtime API Gateway used with NATS to build REST, real time, and RPC APIs";
    homepage = "https://resgate.io";
    license = licenses.mit;
    maintainers = with maintainers; [ farcaller ];
  };
}
