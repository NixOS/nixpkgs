{ fetchFromGitHub, lib, buildGoModule,
  makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep,
  nixosTests }:
buildGoModule rec {
  pname = "buildkite-agent";
  version = "3.40.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "sha256-pd5B7RW13SWtOAwJGxhJBAhihCFkL3TokhWqcy7hVFk=";
  };

  vendorSha256 = "sha256-+LTjtJFHdYv0zeX8RpK0tuLWRpz5jXBwA7ZOvmA6YV0=";

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
    maintainers = with maintainers; [ pawelpacana zimbatm rvl techknowlogick ];
    platforms = with platforms; unix ++ darwin;
  };
}
