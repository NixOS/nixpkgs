{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep }:
let
  version = "2.6.10";
  goPackagePath = "github.com/buildkite/agent";
in
buildGoPackage {
  name = "buildkite-agent-${version}";

  inherit goPackagePath;

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "07065hhhb418w5qlqnyiap45r59paysysbwz1l7dmaw3j4q8m8rg";
  };

  nativeBuildInputs = [ makeWrapper ];

  # on Linux, the TMPDIR is /build which is the same prefix as this package
  # remove once #35068 is merged
  noAuditTmpdir = stdenv.isLinux;

  postInstall = ''
    # Install bootstrap.sh
    mkdir -p $bin/libexec/buildkite-agent
    cp $NIX_BUILD_TOP/go/src/${goPackagePath}/templates/bootstrap.sh $bin/libexec/buildkite-agent
    sed -e "s|#!/bin/bash|#!${bash}/bin/bash|g" -i $bin/libexec/buildkite-agent/bootstrap.sh

    # Fix binary name
    mv $bin/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $bin/bin/buildkite-agent \
      --prefix PATH : '${stdenv.lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}' \
      --set BUILDKITE_BOOTSTRAP_SCRIPT_PATH $bin/libexec/buildkite-agent/bootstrap.sh
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
    maintainers = with maintainers; [ pawelpacana zimbatm ];
    platforms = platforms.unix;
  };
}
