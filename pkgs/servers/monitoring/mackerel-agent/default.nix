{ stdenv, lib, buildGoModule, fetchFromGitHub, makeWrapper, iproute, nettools }:

buildGoModule rec {
  pname = "mackerel-agent";
  version = "0.69.3";

  src = fetchFromGitHub {
    owner = "mackerelio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jkvqqzk6wyjsdsmn2l2cdw8pjqzswlqb9p492czhgrfy065lrqp";
  };

  nativeBuildInputs = [ makeWrapper ];
  checkInputs = lib.optionals (!stdenv.isDarwin) [ nettools ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ iproute ];

  vendorSha256 = "0kjky2mhs6dapnr4xpjpnbibp6y8r320igddplynsfsp8vwrfp7m";

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
