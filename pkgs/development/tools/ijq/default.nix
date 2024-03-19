{ buildGoModule, fetchFromSourcehut, lib, jq, installShellFiles, makeWrapper, scdoc }:

buildGoModule rec {
  pname = "ijq";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-su/PHUt4GpJxt9nm/oYnP1F8EDSl0fUgamWJj1TxuZA=";
  };

  vendorHash = "sha256-X91kW+dpcxd1+vTV1G1al5cdlwWpbUS85Xxf3yeVg1I=";

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
    mainProgram = "ijq";
    homepage = "https://git.sr.ht/~gpanders/ijq";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ justinas SuperSandro2000 ];
  };
}
