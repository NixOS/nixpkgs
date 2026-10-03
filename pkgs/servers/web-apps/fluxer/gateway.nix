{
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  cacert,
  git,
  beamMinimal28Packages,
  cargo,
  rustc,
  bash,
  zstd,
  lib,
}:
let
  beamPackages = beamMinimal28Packages;
  zstdStatic = zstd.override { enableStatic = true; };

  pname = "fluxer-gateway";
  version = "2026.1002.120426";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${pname}@${version}";
    hash = "sha256-88o4InXE0MgnjjaTJchPIsmlmj8/scQZOSC3GqJ++II=";
  };

  copyVendorDeps =
    deps:
    ''cp -r --no-clobber --no-preserve=mode "${deps}/source-registry-0/." "$out/source-registry-0/"'';
  mergeVendorDeps =
    root-dep: extra-dep-list:
    runCommand "merge-vendor-deps" { } ''
      mkdir -p $out

      cp -r --no-preserve=mode "${root-dep}/." "$out/"

      ${lib.join "\n" (lib.map copyVendorDeps extra-dep-list)}
    '';

  cargoRootDep = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-ojD7XNHV8ZULRWPSRfY13aH461d8zfiL6PU/hALS4f4=";
  };
  cargoExtraDeps = [
    (rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-lECOMdkbdWAeL829MrWPWGQI44P+4VMnLIp9Jd+xJJo=";
      sourceRoot = "${src.name}/fluxer_gateway/native/guild_member_list_oset_nif";
    })
    (rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-9HDcMd1qfIOJPIw6D9bLR4rSfbz8Zv/wz9zQe3PoZjM=";
      sourceRoot = "${src.name}/fluxer_gateway/native/push_markdown_plaintext_nif";
    })
  ];
in
beamPackages.rebar3Relx {
  inherit pname version src;

  releaseType = "release";
  profile = "prod";

  env.REBAR_SKIP_PROJECT_PLUGINS = "1";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  checkouts =
    (beamPackages.fetchRebar3Deps {
      inherit version;
      name = pname;
      src = "${src}/fluxer_gateway";
      sha256 = "sha256-rGSvSCUjH+BedJga2Kq2B7diDT5M68l2xmp9hbDD5xI=";
    }).overrideAttrs
      (
        final: prev: {
          nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
            git
            cacert
          ];
          postInstall = ''
            find $out -name .git -prune -execdir rm -r {} +
          '';
        }
      );

  cargoDeps = mergeVendorDeps cargoRootDep cargoExtraDeps;

  postPatch = ''
    cp fluxer_gateway/config/sys.config{.template,}

    patchShebangs --build tools/ci/run.sh
  '';

  preConfigure = ''
    cd fluxer_gateway
  '';

  postConfigure =
    let
      pkg = "eqwalizer_support";
    in
    ''
      mv _checkouts/${pkg}/${pkg} intermediate-dir
      rm -r _checkouts/${pkg}
      mv intermediate-dir _checkouts/${pkg}

      substituteInPlace _checkouts/ezstd/Makefile \
        --replace-fail '@./build_deps.sh' '@${lib.getExe bash} build_deps.sh'

      # Prevent ezstd from fetching and building its own zstd
      mkdir -p _checkouts/ezstd/_build/deps/zstd/lib
      cp ${zstd.dev}/include/*.h _checkouts/ezstd/_build/deps/zstd/lib
      cp ${zstdStatic.out}/lib/libzstd.a _checkouts/ezstd/_build/deps/zstd/lib
    '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    # Execution notes:
    # The following env vars are required for the program to start with a non-arcane error:
    # - RELX_OUT_FILE_PATH, some writeable directory
    # - FLUXER_ERLANG_NODE_NAME, name@fqdn or name@ip
    mainProgram = "fluxer_gateway";
  };
}
