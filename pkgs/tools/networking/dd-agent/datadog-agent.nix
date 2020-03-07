{ lib, stdenv, fetchFromGitHub, buildGoPackage, makeWrapper, pythonPackages, pkgconfig, systemd, hostname, extraTags ? [] }:

let
  # keep this in sync with github.com/DataDog/agent-payload dependency
  payloadVersion = "4.7.1";
  python = pythonPackages.python;

in buildGoPackage rec {
  pname = "datadog-agent";
  version = "6.11.2";
  owner   = "DataDog";
  repo    = "datadog-agent";

  src = fetchFromGitHub {
    inherit owner repo;
    rev    = version;
    sha256 = "1dwdiaf357l9c6b2cps5mdyfma3c1mp96zzxg1826fvz3x8ix68z";
  };

  subPackages = [
    "cmd/agent"
    "cmd/cluster-agent"
    "cmd/dogstatsd"
    "cmd/py-launcher"
    "cmd/trace-agent"
  ];
  goDeps = ./datadog-agent-deps.nix;
  goPackagePath = "github.com/${owner}/${repo}";


  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ systemd ];
  PKG_CONFIG_PATH = "${python}/lib/pkgconfig";


  preBuild = let
    ldFlags = stdenv.lib.concatStringsSep " " [
      "-X ${goPackagePath}/pkg/version.Commit=${src.rev}"
      "-X ${goPackagePath}/pkg/version.AgentVersion=${version}"
      "-X ${goPackagePath}/pkg/serializer.AgentPayloadVersion=${payloadVersion}"
      "-X ${goPackagePath}/pkg/collector/py.pythonHome=${python}"
      "-r ${python}/lib"
    ];
  in ''
    buildFlagsArray=( "-tags" "ec2 systemd cpython process log secrets ${lib.concatStringsSep " " extraTags}" "-ldflags" "${ldFlags}")
  '';

  # DataDog use paths relative to the agent binary, so fix these.
  postPatch = ''
    sed -e "s|PyChecksPath =.*|PyChecksPath = \"$bin/${python.sitePackages}\"|" \
        -e "s|distPath =.*|distPath = \"$bin/share/datadog-agent\"|" \
        -i cmd/agent/common/common_nix.go
    sed -e "s|/bin/hostname|${lib.getBin hostname}/bin/hostname|" \
        -i pkg/util/hostname_nix.go
  '';

  # Install the config files and python modules from the "dist" dir
  # into standard paths.
  postInstall = ''
    mkdir -p $bin/${python.sitePackages} $bin/share/datadog-agent
    cp -R $src/cmd/agent/dist/conf.d $bin/share/datadog-agent
    cp -R $src/cmd/agent/dist/{checks,utils,config.py} $bin/${python.sitePackages}

    cp -R $src/pkg/status/dist/templates $bin/share/datadog-agent

    wrapProgram "$bin/bin/agent" \
      --set PYTHONPATH "$bin/${python.sitePackages}" \
      --prefix LD_LIBRARY_PATH : ${systemd.lib}/lib
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
