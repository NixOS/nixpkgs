{ fetchFromGitHub, lib, buildGoModule,
  makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep,
  nixosTests }:
buildGoModule rec {
  name = "buildkite-agent-${version}";
  version = "3.33.3";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "sha256-RCKHVFYYcWraUwsGuD/anmWpNwc7cHc9jm0LwR9WRzA=";
  };

  vendorSha256 = "sha256-n3XRxpEKjHf7L7fcGscWTVKBtot9waZbLoS9cG0kHfI=";

  postPatch = ''
    substituteInPlace bootstrap/shell/shell.go --replace /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  postInstall = ''
    # Fix binary name
    mv $out/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $out/bin/buildkite-agent \
      --prefix PATH : '${lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}'
  '';

  passthru.tests = {
    smoke-test = nixosTests.buildkite-agents;
  };

  meta = with lib; {
    description = "Build runner for buildkite.com";
    longDescription = ''
      The buildkite-agent is a small, reliable, and cross-platform build runner
      that makes it easy to run automated builds on your own infrastructure.
      It’s main responsibilities are polling buildkite.com for work, running
      build jobs, reporting back the status code and output log of the job,
      and uploading the job's artifacts.
    '';
    homepage = "https://buildkite.com/docs/agent";
    license = licenses.mit;
    maintainers = with maintainers; [ pawelpacana zimbatm rvl ];
    platforms = with platforms; unix ++ darwin;
  };
}
