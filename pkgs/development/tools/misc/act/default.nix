{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "1sn36686nfmqvhmippdapk0pxqx3x1q4dwdyhjr8j8scyfrk68iv";
  };

  modSha256 = "0ghp61m8fxg1iwq2ypmp99cqv3n16c06v2xzg9v34299vmd89gi2";

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://circleci.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
