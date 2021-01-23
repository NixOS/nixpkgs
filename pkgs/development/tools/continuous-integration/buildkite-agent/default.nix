{ fetchFromGitHub, stdenv, buildGoModule,
  makeWrapper, coreutils, git, openssh, bash, gnused, gnugrep }:
buildGoModule rec {
  name = "buildkite-agent-${version}";
  version = "3.26.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "1z8hiamg3h1fnsmr8j5l9q6c8cd81lqmd00gcmz4spw73pqfxg3r";
  };

  vendorSha256 = "1kxnpn4py8a2rz1gwg0y3yiwcwphj38pkp2k9z1p85ccm2wblljz";

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
    homepage = "https://buildkite.com/docs/agent";
    license = licenses.mit;
    maintainers = with maintainers; [ pawelpacana zimbatm rvl ];
    platforms = with platforms; unix ++ darwin;
  };
}
