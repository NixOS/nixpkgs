{ stdenv, fetchFromGitHub, buildGoPackage, makeWrapper, pythonPackages, pkgconfig }:

let
  # keep this in sync with github.com/DataDog/agent-payload dependency
  payloadVersion = "4.7";

in buildGoPackage rec {
  name = "datadog-agent-${version}";
  version = "6.1.4";
  owner   = "DataDog";
  repo    = "datadog-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = "a8ee76deb11fa334470d9b8f2356214999980894";
    sha256 = "06grcwwbfvcw1k1d4nqrasrf76qkpik1gsw60zwafllfd9ffhl1v";
  };

  subPackages = [
    "cmd/agent"
    "cmd/dogstatsd"
    "cmd/py-launcher"
    "cmd/cluster-agent"
  ];
  goDeps = ./deps.nix;
  goPackagePath = "github.com/${owner}/${repo}";

  # Explicitly set this here to allow it to be overridden.
  python = pythonPackages.python;

  nativeBuildInputs = [ pkgconfig makeWrapper ];
  PKG_CONFIG_PATH = "${python}/lib/pkgconfig";

  buildFlagsArray = let
    ldFlags = stdenv.lib.concatStringsSep " " [
      "-X ${goPackagePath}/pkg/version.Commit=${src.rev}"
      "-X ${goPackagePath}/pkg/version.AgentVersion=${version}"
      "-X ${goPackagePath}/pkg/serializer.AgentPayloadVersion=${payloadVersion}"
      "-X ${goPackagePath}/pkg/collector/py.pythonHome=${python}"
      "-r ${python}/lib"
    ];
  in [
    "-ldflags=${ldFlags}"
  ];
  buildFlags = "-tags cpython";

  # DataDog use paths relative to the agent binary, so fix these.
  postPatch = ''
    sed -e "s|PyChecksPath =.*|PyChecksPath = \"$bin/${python.sitePackages}\"|" \
        -e "s|distPath =.*|distPath = \"$bin/share/datadog-agent\"|" \
        -i cmd/agent/common/common_nix.go
  '';

  # Install the config files and python modules from the "dist" dir
  # into standard paths.
  postInstall = ''
    mkdir -p $bin/${python.sitePackages} $bin/share/datadog-agent
    cp -R $src/cmd/agent/dist/{conf.d,trace-agent.conf} $bin/share/datadog-agent
    cp -R $src/cmd/agent/dist/{checks,utils,config.py} $bin/${python.sitePackages}

    cp -R $src/pkg/status/dist/templates $bin/share/datadog-agent

    wrapProgram "$bin/bin/agent" \
        --set PYTHONPATH "$bin/${python.sitePackages}"
  '';

  meta = with stdenv.lib; {
    description = ''
      Event collector for the DataDog analysis service
      -- v6 new golang implementation.
    '';
    homepage    = https://www.datadoghq.com;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice domenkozar rvl ];
  };
}
