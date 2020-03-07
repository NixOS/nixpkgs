{ fetchFromGitHub, stdenv, buildGoPackage,
  makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep }:
buildGoPackage rec {
  name = "buildkite-agent-${version}";
  version = "3.17.0";

  goPackagePath = "github.com/buildkite/agent";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "0a7x919kxnpdn0pnhc5ilx1z6ninx8zgjvsd0jcg4qwh0qqp5ppr";
  };
  postPatch = ''
    substituteInPlace bootstrap/shell/shell.go --replace /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [ makeWrapper ];

  # on Linux, the TMPDIR is /build which is the same prefix as this package
  # remove once #35068 is merged
  noAuditTmpdir = stdenv.isLinux;

  postInstall = ''
    # Fix binary name
    mv $bin/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $bin/bin/buildkite-agent \
      --prefix PATH : '${stdenv.lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}'
  '';

  meta = with stdenv.lib; {
    description = "Build runner for buildkite.com";
    longDescription = ''
      The buildkite-agent is a small, reliable, and cross-platform build runner
      that makes it easy to run automated builds on your own infrastructure.
      It’s main responsibilities are polling buildkite.com for work, running
      build jobs, reporting back the status code and output log of the job,
      and uploading the job's artifacts.
    '';
    homepage = https://buildkite.com/docs/agent;
    license = licenses.mit;
    maintainers = with maintainers; [ pawelpacana zimbatm rvl ];
    platforms = platforms.unix;
  };
}
