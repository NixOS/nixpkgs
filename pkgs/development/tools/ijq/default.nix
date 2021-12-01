{ buildGoModule, fetchFromSourcehut, lib, jq, installShellFiles, makeWrapper, scdoc }:

buildGoModule rec {
  pname = "ijq";
  version = "0.3.6";

  src = fetchFromSourcehut {
    owner = "~gpanders";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mPO3P+NGFIoHuvMFwj87S8H8LQx7QpfPy2zi91la2C0=";
  };

  vendorSha256 = "sha256-HbrmfZ/P5bUF7Qio5L1sb/HAYk/tL2SOmxHCXvSw72I=";

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
