{ lib, buildGoModule, makeWrapper, fetchFromGitHub, pythonPackages, pkg-config, systemd, hostname, extraTags ? [] }:

let
  # keep this in sync with github.com/DataDog/agent-payload dependency
  payloadVersion = "4.78.0";
  python = pythonPackages.python;
  owner   = "DataDog";
  repo    = "datadog-agent";
  goPackagePath = "github.com/${owner}/${repo}";

in buildGoModule rec {
  pname = "datadog-agent";
  version = "7.33.1";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = version;
    sha256 = "sha256-H8apgLdm90/gVsqcCSc3gymgUUP2AWcNPgV9394UUeQ=";
  };

  vendorSha256 = "sha256-qIm9ZIQTNmKUtTMBsGzH0t4MrIAvksea9t7p5cC6ykk=";

  subPackages = [
    "cmd/agent"
    "cmd/cluster-agent"
    "cmd/dogstatsd"
    "cmd/py-launcher"
    "cmd/trace-agent"
  ];


  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ systemd ];
  PKG_CONFIG_PATH = "${python}/lib/pkgconfig";

  preBuild = let
    ldFlags = lib.concatStringsSep " " [
      "-X ${goPackagePath}/pkg/version.Commit=${src.rev}"
      "-X ${goPackagePath}/pkg/version.AgentVersion=${version}"
      "-X ${goPackagePath}/pkg/serializer.AgentPayloadVersion=${payloadVersion}"
      "-X ${goPackagePath}/pkg/collector/py.pythonHome=${python}"
      "-r ${python}/lib"
    ];
  in ''
    buildFlagsArray=( "-tags" "ec2 systemd cpython process log secrets ${lib.concatStringsSep " " extraTags}" "-ldflags" "${ldFlags}")
    # Keep directories to generate in sync with tasks/go.py
    go generate ./pkg/status ./cmd/agent/gui
  '';

  # DataDog use paths relative to the agent binary, so fix these.
  postPatch = ''
    sed -e "s|PyChecksPath =.*|PyChecksPath = \"$out/${python.sitePackages}\"|" \
        -e "s|distPath =.*|distPath = \"$out/share/datadog-agent\"|" \
        -i cmd/agent/common/common_nix.go
    sed -e "s|/bin/hostname|${lib.getBin hostname}/bin/hostname|" \
        -i pkg/util/hostname_nix.go
  '';

  # Install the config files and python modules from the "dist" dir
  # into standard paths.
  postInstall = ''
    mkdir -p $out/${python.sitePackages} $out/share/datadog-agent
    cp -R $src/cmd/agent/dist/conf.d $out/share/datadog-agent
    cp -R $src/cmd/agent/dist/{checks,utils,config.py} $out/${python.sitePackages}

    cp -R $src/pkg/status/templates $out/share/datadog-agent

    wrapProgram "$out/bin/agent" \
      --set PYTHONPATH "$out/${python.sitePackages}" \
      --prefix LD_LIBRARY_PATH : ${lib.getLib systemd}/lib
  '';

  meta = with lib; {
    description = ''
      Event collector for the DataDog analysis service
      -- v6 new golang implementation.
    '';
    homepage    = "https://www.datadoghq.com";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice domenkozar rvl ];
  };
}
