{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute2, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.73.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ev7GhJjGNgMlkvfGV2oi2uvtvlDTTIo3YQAM87KC4r0=";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute2 ];

  vendorSha256 = "sha256-K/HnlrXFgLsm+9161RkeTBbToY8SoHVinY2aY2+S6p4=";

  subPackages = [ "." ];

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.gitcommit=v${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/mackerel-agent \
      --prefix PATH : "${lib.makeBinPath buildInputs}"
  '';

  doCheck = true;

  meta = with lib; {
    description = "System monitoring service for mackerel.io";
    homepage = "https://github.com/mackerelio/mackerel-agent";
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
  };
}
