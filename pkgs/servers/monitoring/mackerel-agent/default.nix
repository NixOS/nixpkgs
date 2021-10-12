{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute2, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.72.2";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oiY3L4aBF+QhpZDTkwTmWPLoTgm+RUYCov5+gOxJqew=";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute2 ];

  vendorSha256 = "sha256-dfBJXA1Lc4+TL1nIk4bZ4m4QEO1r29GPyGtZrE+LrZc=";

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
