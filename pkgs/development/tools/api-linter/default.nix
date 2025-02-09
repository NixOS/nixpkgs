{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-3uxPHSmIFrkAm82sqQxWKzJwU3cFhTDVsJYp8cENaRg=";
  };

  vendorHash = "sha256-egAZ4CeSSStfkN2mGgzGHTBojHKHoVEf3o0oi+OpMkw=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # reference: https://github.com/googleapis/api-linter/blob/v1.60.0/.github/workflows/release.yaml#L76
  preBuild = ''
    cat > cmd/api-linter/version.go <<EOF
    package main
    const version = "${version}"
    EOF
  '';

  meta = with lib; {
    description = "Linter for APIs defined in protocol buffers";
    homepage = "https://github.com/googleapis/api-linter/";
    changelog = "https://github.com/googleapis/api-linter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
  };
}
