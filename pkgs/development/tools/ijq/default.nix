{ buildGoModule, fetchFromSourcehut, lib, jq, installShellFiles, makeWrapper, scdoc }:

buildGoModule rec {
  pname = "ijq";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EQfCEdQIrjg38JjjePNDNWKi0cFezjYvIGVJajbf9jw=";
  };

  vendorSha256 = "sha256-DX8m5FsqMZnzk1wgJA/ESZl0QeDv3p9huF4h1HY9DIA=";

  nativeBuildInputs = [ installShellFiles makeWrapper scdoc ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  postBuild = ''
    scdoc < ijq.1.scd > ijq.1
    installManPage ijq.1
  '';

  postInstall = ''
    wrapProgram "$out/bin/ijq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = with lib; {
    description = "Interactive wrapper for jq";
    homepage = "https://git.sr.ht/~gpanders/ijq";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ justinas SuperSandro2000 ];
  };
}
