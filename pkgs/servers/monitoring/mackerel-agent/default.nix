{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute2, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.71.2";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O67xzL4avCOh2x6qJCScOWR2TS1hfP5S6jHHELNbZWQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute2 ];

  vendorSha256 = "sha256-iFWQoAnB0R6XwjdPvOWJdNTmEZ961zE51vDrmZ7r4Jk=";

  subPackages = [ "." ];

  buildFlagsArray = ''
    -ldflags=
    -X=main.version=${version}
    -X=main.gitcommit=v${version}
  '';

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
