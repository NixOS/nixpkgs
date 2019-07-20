{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mkcert";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = pname;
    rev = "v${version}";
    sha256 = "1aadnsx5pfmryf8mgxg9g0i083dm1pmrc6v4ln2mm3n89wwqc9b7";
  };

  modSha256 = "0snvvwhyfq01nwgjz55dgd5skpg7z0dzix7sdag90cslbrr983i1";

  meta = with lib; {
    homepage = https://github.com/FiloSottile/mkcert;
    description = "A simple tool for making locally-trusted development certificates";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
