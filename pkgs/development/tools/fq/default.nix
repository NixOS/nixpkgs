{ lib, buildGo117Module, fetchFromGitHub }:

buildGo117Module rec {
  pname = "fq";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    sha256 = "sha256-ykjt9MPkN5dgTaY2VhApNt5DKh9TFapMpoHwLdpOKcw=";
  };

  vendorSha256 = "sha256-89rSpxhP35wreo+0AqM+rDICCPchF+yFVvrTtZ2Xwr4=";

  meta = with lib; {
    description = "jq for binary formats";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
