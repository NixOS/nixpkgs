{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "api-linter";
  version = "1.56.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "api-linter";
    rev = "v${version}";
    hash = "sha256-X8S8hfdfoqWRhJIuhNEZFXIAW1k5nFvE5v/7homO1Ow=";
  };

  vendorHash = "sha256-6MvXVHg4EH5S37JnY0jnAFjDplQINWPFyd54c1W/oAE=";

  subPackages = [ "cmd/api-linter" ];

  ldflags = [
    "-s"
    "-w"
  ];

  # reference: https://github.com/googleapis/api-linter/blob/v1.56.1/.github/workflows/release.yaml#L76
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
