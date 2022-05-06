{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute2, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.72.9";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+3a0FyVf5AB85gGGBI8/ssLBqj9Kp3w9DUNbSaAtXvA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute2 ];

  vendorSha256 = "sha256-4hdy+Yr9EoUjJ4+pJ2ZEPGlnq+4sx5JLm92eFFav6tU=";

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
