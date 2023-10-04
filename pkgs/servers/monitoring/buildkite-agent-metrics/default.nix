{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.8.0";

  outputs = [ "out" "lambda" ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-QPtjKjUGKlqgklZ0wUOJ1lXuXHhWVC83cEJ4QVtgdl4=";
  };

  vendorHash = "sha256-KgTzaF8dFD4VwcuSqmOy2CSfLuA0rjFwtCqGNYHFFlc=";

  postInstall = ''
    mkdir -p $lambda/bin
    mv $out/bin/lambda $lambda/bin
  '';

  meta = with lib; {
    description = "A command-line tool (and Lambda) for collecting Buildkite agent metrics";
    homepage = "https://github.com/buildkite/buildkite-agent-metrics";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
