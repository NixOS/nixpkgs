{ lib, buildGoPackage, makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep
, src, version, hasBootstrapScript, postPatch ? ""
, ... }:
let
  goPackagePath = "github.com/buildkite/agent";
in
buildGoPackage {
  pname = "buildkite-agent";
  inherit version;

  inherit goPackagePath src postPatch;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    ${lib.optionalString hasBootstrapScript ''
    # Install bootstrap.sh
    mkdir -p $out/libexec/buildkite-agent
    cp $NIX_BUILD_TOP/go/src/${goPackagePath}/templates/bootstrap.sh $out/libexec/buildkite-agent
    sed -e "s|#!/bin/bash|#!${bash}/bin/bash|g" -i $out/libexec/buildkite-agent/bootstrap.sh
    ''}

    # Fix binary name
    mv $out/bin/{agent,buildkite-agent}

    # These are runtime dependencies
    wrapProgram $out/bin/buildkite-agent \
      ${lib.optionalString hasBootstrapScript "--set BUILDKITE_BOOTSTRAP_SCRIPT_PATH $out/libexec/buildkite-agent/bootstrap.sh"} \
      --prefix PATH : '${lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}'
  '';

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
    platforms = platforms.unix;
  };
}
