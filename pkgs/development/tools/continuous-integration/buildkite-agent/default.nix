{ stdenv, fetchurl, makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep }:

stdenv.mkDerivation rec {
  version = "2.1.13";
  name = "buildkite-agent-${version}";
  dontBuild = true;

  src = fetchurl {
    url = "https://github.com/buildkite/agent/releases/download/v${version}/buildkite-agent-linux-386-${version}.tar.gz";
    sha256 = "bd40c2ba37b3b54b875241a32b62190a4cf4c15e2513c573f1626a3ca35c8657";
  };

  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = ".";
  installPhase = ''
    install -Dt "$out/bin/" buildkite-agent

    mkdir -p $out/share
    mv hooks bootstrap.sh $out/share/
  '';

  postFixup = ''
    substituteInPlace $out/share/bootstrap.sh \
      --replace "#!/bin/bash" "#!$(type -P bash)"
    wrapProgram $out/bin/buildkite-agent \
      --set PATH '"${stdenv.lib.makeBinPath [ openssh git coreutils gnused gnugrep ]}:$PATH"'
  '';

  meta = {
    description = "Build runner for buildkite.com";
    longDescription = ''
      The buildkite-agent is a small, reliable, and cross-platform build runner
      that makes it easy to run automated builds on your own infrastructure.
      It’s main responsibilities are polling buildkite.com for work, running
      build jobs, reporting back the status code and output log of the job,
      and uploading the job's artifacts.
    '';
    homepage = https://buildkite.com/docs/agent;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.pawelpacana ];
    platforms = stdenv.lib.platforms.linux;
  };
}
