{ lib
, stdenv
, cmake
, buildGoModule
, makeWrapper
, fetchFromGitHub
, pythonPackages
, pkg-config
, systemd
, hostname
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, extraTags ? [ ]
}:

let
  # keep this in sync with github.com/DataDog/agent-payload dependency
  payloadVersion = "4.78.0";
  python = pythonPackages.python;
  owner   = "DataDog";
  repo    = "datadog-agent";
  goPackagePath = "github.com/${owner}/${repo}";
  version = "7.38.1";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = version;
    sha256 = "sha256-bG8wsSQvZcG4/Th6mWVdVX9vpeYBZx8FxwdYXpIdXnU=";
  };
  rtloader = stdenv.mkDerivation {
    pname = "datadog-agent-rtloader";
    src = "${src}/rtloader";
    inherit version;
    nativeBuildInputs = [ cmake ];
    buildInputs = [ python ];
    cmakeFlags = ["-DBUILD_DEMO=OFF" "-DDISABLE_PYTHON2=ON"];
  };

in buildGoModule rec {
  pname = "datadog-agent";
  inherit src version;

  doCheck = false;

  vendorSha256 = "sha256-bGDf48wFa32hURZfGN5pCMmslC3PeLNayKcl5cfjq9M=";

  subPackages = [
    "cmd/agent"
    "cmd/cluster-agent"
    "cmd/dogstatsd"
    "cmd/py-launcher"
    "cmd/trace-agent"
  ];


  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [rtloader] ++ lib.optionals withSystemd [ systemd ];
  PKG_CONFIG_PATH = "${python}/lib/pkgconfig";

  tags = [
    "ec2"
    "python"
    "process"
    "log"
    "secrets"
  ]
  ++ lib.optionals withSystemd [ "systemd" ]
  ++ extraTags;

  ldflags = [
    "-X ${goPackagePath}/pkg/version.Commit=${src.rev}"
    "-X ${goPackagePath}/pkg/version.AgentVersion=${version}"
    "-X ${goPackagePath}/pkg/serializer.AgentPayloadVersion=${payloadVersion}"
    "-X ${goPackagePath}/pkg/collector/python.pythonHome3=${python}"
    "-X ${goPackagePath}/pkg/config.DefaultPython=3"
    "-r ${python}/lib"
  ];

  preBuild = ''
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
    cp -R --no-preserve=mode $src/cmd/agent/dist/conf.d $out/share/datadog-agent
    rm -rf $out/share/datadog-agent/conf.d/{apm.yaml.default,process_agent.yaml.default,winproc.d}
    cp -R $src/cmd/agent/dist/{checks,utils,config.py} $out/${python.sitePackages}

    cp -R $src/pkg/status/templates $out/share/datadog-agent

    wrapProgram "$out/bin/agent" \
      --set PYTHONPATH "$out/${python.sitePackages}"'' + lib.optionalString withSystemd '' \
      --prefix LD_LIBRARY_PATH : '' + lib.makeLibraryPath [ (lib.getLib systemd) rtloader ];

  meta = with lib; {
    description = ''
      Event collector for the DataDog analysis service
      -- v6 new golang implementation.
    '';
    homepage    = "https://www.datadoghq.com";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice domenkozar rvl viraptor ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
