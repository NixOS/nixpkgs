{
  lib,
  stdenv,
  cmake,
  buildGoModule,
  makeWrapper,
  fetchFromGitHub,
  pythonPackages,
  pkg-config,
  systemd,
  hostname,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  withDocker ? true,
  extraTags ? [ ],
  testers,
  datadog-agent,
}:

let
  # keep this in sync with github.com/DataDog/agent-payload dependency
  payloadVersion = "5.0.164";
  python = pythonPackages.python;
  owner = "DataDog";
  repo = "datadog-agent";
  goPackagePath = "github.com/${owner}/${repo}";
  version = "7.71.2";

  src = fetchFromGitHub {
    inherit owner repo;
    tag = version;
    hash = "sha256-WERO2vs0x5w+9L68BucvcuBWF2qoYU6qP7FvCYrnfrc=";
  };
  rtloader = stdenv.mkDerivation {
    pname = "datadog-agent-rtloader";
    src = "${src}/rtloader";
    inherit version;
    nativeBuildInputs = [ cmake ];
    buildInputs = [ python ];
    cmakeFlags = [
      "-DBUILD_DEMO=OFF"
      "-DDISABLE_PYTHON2=ON"
    ];
  };

in
buildGoModule rec {
  pname = "datadog-agent";
  inherit src version;

  doCheck = false;

  vendorHash = "sha256-lL31RZqSQy3iqdJ/07pxjeMMFCK9HOX2TI7xvIa2Z3s=";

  subPackages = [
    "cmd/agent"
    "cmd/cluster-agent"
    "cmd/dogstatsd"
    "cmd/trace-agent"
  ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [ rtloader ] ++ lib.optionals withSystemd [ systemd ];

  proxyVendor = true;

  env.PKG_CONFIG_PATH = "${python}/lib/pkgconfig";

  tags = [
    "ec2"
    "kubelet"
    "python"
    "process"
    "log"
    "secrets"
    "zlib"
  ]
  ++ lib.optionals withSystemd [ "systemd" ]
  ++ lib.optionals withDocker [ "docker" ]
  ++ extraTags;

  ldflags = [
    "-X ${goPackagePath}/pkg/version.Commit=${src.rev}"
    "-X ${goPackagePath}/pkg/version.AgentVersion=${version}"
    "-X ${goPackagePath}/pkg/serializer.AgentPayloadVersion=${payloadVersion}"
    "-X ${goPackagePath}/pkg/collector/python.pythonHome3=${python}"
    "-X ${goPackagePath}/pkg/config/setup.DefaultPython=3"
    "-r ${python}/lib"
  ];

  # DataDog use paths relative to the agent binary, so fix these.
  # We can't just point these to $out since that would introduce self-referential paths in the go modules,
  # which are a fixed-output derivation. However, the patches aren't picked up if we skip them when building
  # the modules. So we'll just traverse from the bin back to the out folder.
  postPatch = ''
    sed -e "s|PyChecksPath =.*|PyChecksPath = filepath.Join(_here, \"..\", \"${python.sitePackages}\")|" \
        -e "s|distPath =.*|distPath = filepath.Join(_here, \"..\", \"share\", \"datadog-agent\")|" \
        -i pkg/util/defaultpaths/path_nix.go
    sed -e "s|/bin/hostname|${lib.getBin hostname}/bin/hostname|" \
        -i pkg/util/hostname/fqdn_nix.go
  '';

  # Install the config files and python modules from the "dist" dir
  # into standard paths.
  postInstall = ''
    mkdir -p $out/${python.sitePackages} $out/share/datadog-agent
    cp -R --no-preserve=mode $src/cmd/agent/dist/conf.d $out/share/datadog-agent
    rm -rf $out/share/datadog-agent/conf.d/{apm.yaml.default,process_agent.yaml.default,winproc.d,agentcrashdetect.d,myapp.d}
    cp -R $src/cmd/agent/dist/{checks,utils,config.py} $out/${python.sitePackages}

    wrapProgram "$out/bin/agent" \
      --set PYTHONPATH "$out/${python.sitePackages}"''
  + lib.optionalString withSystemd " --prefix LD_LIBRARY_PATH : ${
     lib.makeLibraryPath [
       (lib.getLib systemd)
       rtloader
     ]
   }";

  passthru.tests.version = testers.testVersion {
    package = datadog-agent;
    command = "agent version";
  };

  meta = with lib; {
    description = ''
      Event collector for the DataDog analysis service
      -- v6 new golang implementation.
    '';
    homepage = "https://www.datadoghq.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      thoughtpolice
    ];
  };
}
