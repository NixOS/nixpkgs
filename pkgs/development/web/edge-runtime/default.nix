{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  darwin,
  openssl,
  pkg-config,
}:

let
  pname = "edge-runtime";
  version = "1.14.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-63XStzO4Jt6ObWuzcBf2QwCIWsStXvhQ0XaJabELhWg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-JwwdvvpqgSbl0Xyb5pQ5hzZRrrCnDSjwV+ikdO2pXCk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreFoundation
        SystemConfiguration
      ]
    );

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix { };

  passthru.updateScript = nix-update-script { };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # tries to make a network access
    "--skip=deno_runtime::test::test_main_rt_fs"
    "--skip=deno_runtime::test::test_main_runtime_creation"
    "--skip=deno_runtime::test::test_os_env_vars"
    "--skip=deno_runtime::test::test_os_ops"
    "--skip=deno_runtime::test::test_user_runtime_creation"
    "--skip=test_custom_readable_stream_response"
    "--skip=test_import_map_file_path"
    "--skip=test_import_map_inline"
    "--skip=test_main_worker_options_request"
    "--skip=test_main_worker_post_request"
    "--skip=test_null_body_with_204_status"
    "--skip=test_null_body_with_204_status_post"
    "--skip=test_file_upload"
    "--skip=test_oak_server"
    "--skip=test_tls_throw_invalid_data"
    "--skip=test_user_worker_json_imports"
    "--skip=node::analyze::tests::test_esm_code_with_node_globals"
    "--skip=node::analyze::tests::test_esm_code_with_node_globals_with_shebang"
  ];

  meta = with lib; {
    description = "A server based on Deno runtime, capable of running JavaScript, TypeScript, and WASM services";
    mainProgram = "edge-runtime";
    homepage = "https://github.com/supabase/edge-runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
