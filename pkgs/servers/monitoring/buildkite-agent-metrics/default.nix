{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.9.3";

  outputs = [ "out" "lambda" ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
    hash = "sha256-DepIptvR4i0+/45stCMErJtDeAFIDiNbhioitQ8gYBs=";
  };

  vendorHash = "sha256-YEvVGtfhe/RBeuD87C2BNOFEeK40JDidX4loSLdBwhs=";

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
