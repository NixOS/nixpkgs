{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "lurk";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "jakwai01";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vvz1CWNpMbVpICL42VQHLM7AWSONGSXP5kfZ8rZlw8M=";
  };

  cargoSha256 = "sha256-AoFkgm13vj/18GOuSIgzs+xk82lSQ6zGpq4QVWcClv8=";

  meta = with lib; {
    description = "A simple and pretty alternative to strace";
    homepage = "https://github.com/jakwai01/lurk";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
