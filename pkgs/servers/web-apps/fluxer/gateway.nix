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

  versioning = lib.importJSON ./versioning.json;

  pname = "fluxer-gateway";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    inherit (versioning) rev hash;
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
    hash = versioning.cargoHash;
  };
  cargoExtraDeps = [
    (rustPlatform.fetchCargoVendor {
      inherit src;
      hash = versioning.guildMemberListNifHash;
      sourceRoot = "${src.name}/fluxer_gateway/native/guild_member_list_oset_nif";
    })
    (rustPlatform.fetchCargoVendor {
      inherit src;
      hash = versioning.pushMarkdownPlaintextHash;
      sourceRoot = "${src.name}/fluxer_gateway/native/push_markdown_plaintext_nif";
    })
  ];
in
beamPackages.rebar3Relx {
  inherit pname src;
  inherit (versioning) version;

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
      inherit (versioning) version;
      name = pname;
      src = "${src}/fluxer_gateway";
      sha256 = versioning.rebarHash;
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

  postInstall = ''
    mv $out/fluxer_gateway $out/fluxer_gateway-unwrapped
    makeWrapper \
      $out/fluxer_gateway-unwrapped \
      $out/fluxer_gateway \
      --set-default RELX_OUT_FILE_PATH '$(mktemp -d)' \
      --set-default FLUXER_ERLANG_NODE_NAME fluxer-gateway@127.0.0.1
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
    mainProgram = "fluxer_gateway";
  };
}
