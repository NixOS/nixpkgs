{ lib, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoModule rec {
  pname = "clair";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "14dh9iv2g138rivvfk135m3l90kk6c1ln1iqxhbi7s99h1jixbqw";
  };

  vendorSha256 = "0x31n50vd8660z816as6kms5dkv87b0mhblccpkvd9cbvcv2n37a";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clair \
      --prefix PATH : "${lib.makeBinPath [ rpm xz ]}"
  '';

  meta = with lib; {
    description = "Vulnerability Static Analysis for Containers";
    homepage = "https://github.com/quay/clair";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}