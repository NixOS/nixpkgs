{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.9.2";

  outputs = [ "out" "lambda" ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-JYpsQUIKTlQz1VUmPfTzvgh++0p3NAoa105mvGoqgt8=";
  };

  vendorHash = "sha256-2EbZLLaddR7oWXb9H9E35foevp6gMbWfoymDf2lQuto=";

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
