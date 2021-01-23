{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.71.0";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qU2rU5uUBRFFXyDF+qrOpOOKewlN5SQQHoZW2twtNw4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute ];

  vendorSha256 = "sha256-EwQ5KaiVQbYISETcOMC173O99GeyyH1X5Q8YsWXsv3o=";

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
    platforms = platforms.all;
  };
}
