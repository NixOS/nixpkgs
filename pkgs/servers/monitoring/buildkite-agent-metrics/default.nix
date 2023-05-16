{ lib
, buildGoModule
, fetchFromGitHub
<<<<<<< HEAD
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.7.0";
=======
, fetchpatch
}:
buildGoModule rec {
  pname = "buildkite-agent-metrics";
  version = "5.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "lambda" ];

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "buildkite-agent-metrics";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+DK8OP/rOWIBw+5Fprd5gzFo1rJDkDt4G20iUVmrfLw=";
  };

  vendorHash = "sha256-QfvHTJQEG5nvJy5ZZ9c66JYWMcR9Irow8OOyqDDjQN0=";
=======
    sha256 = "XZYVCSJ/DIwoLrz37aQ3yW3RUhOhorY8L1AsAWxywcg=";
  };

  vendorSha256 = "UIkU3i45IEXWHdiakTj7f4W9kR49k4A93msfkqeXmQQ=";

  patches = [
    # Necessary to support passing the agent token in an env var, rather than on
    # the command line. Should be removed upon the next release.
    (fetchpatch {
      name = "BUILDKITE_AGENT_TOKEN-env-var.patch";
      url = "https://github.com/buildkite/buildkite-agent-metrics/commit/6c40b478b95f0e05fc12b87158222a9ff68169e0.patch";
      sha256 = "Y4m9qGyPIROSqOY6G6xRQfFENEG4bFF3q5dZcHI4XiY=";
    })
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
