{ lib, buildGoModule, fetchFromGitHub, makeWrapper, rpm, xz }:

buildGoModule rec {
  pname = "clair";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "quay";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bvwh3ghxb3ynq8a07ka9i0rzaqg1aikxvqxmpjkwjvhwk63lwqd";
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
