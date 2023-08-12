{ lib
, rustPlatform
, fetchFromGitHub
, buildNpmPackage
, bash
, cairo
, deno
, fetchurl
, go
, lld
, makeWrapper
, nsjail
, openssl
, pango
, pixman
, pkg-config
, python3
, rust
, rustfmt
, stdenv
, swagger-cli
}:

let
  pname = "windmill";
  version = "1.131.0";

  fullSrc = fetchFromGitHub {
    owner = "windmill-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-w9WkXoBHdQZUTOveHMyK/iyPB0B1e6bYJ/8qMXH8gFw=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.pip-tools ]);

  frontend-build = buildNpmPackage {
    inherit version;

    pname = "windmill-ui";
    src = fullSrc;

    sourceRoot = "${fullSrc.name}/frontend";

    npmDepsHash = "sha256-2bKrpvh7x8mlhNnHFKVrZJzrWy2yynXbQW3l63HGNTg=";

    preBuild = ''
      npm run generate-backend-client
    '';

    buildInputs = [ pixman cairo pango ];
    nativeBuildInputs = [ python3 pkg-config ];

    installPhase = ''
      mkdir -p $out/share
      mv build $out/share/windmill-frontend
    '';
  };
in
rustPlatform.buildRustPackage {
  inherit pname version;
  src = "${fullSrc}/backend";

  env = {
    SQLX_OFFLINE = "true";
    RUSTY_V8_ARCHIVE =
      let
        arch = rust.toRustTarget stdenv.hostPlatform;
        fetch_librusty_v8 = args:
          fetchurl {
            name = "librusty_v8-${args.version}";
            url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${arch}.a";
            sha256 = args.shas.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
            meta = { inherit (args) version; };
          };
      in
      fetch_librusty_v8 {
        version = "0.73.0";
        shas = {
          x86_64-linux = "sha256-rDthrqAs4yUl9BpFm8yJ2sKbUImydMMZegUBhcu6vdk=";
          aarch64-linux = "sha256-fM7yteYrPxCLNIUKvUpH6XTdD2aYsK4SEyrkknZgzLk=";
          x86_64-darwin = "sha256-3c3oNq6WJkFR7E/EeJ7CnN+JO7X5x+wSlqo39TbEDQk=";
          aarch64-darwin = "sha256-fO1R99XWfgAGcZXJX8nHbfnPZOlz28kXO7fkkeEF43A=";
        };
      };
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "progenitor-0.3.0" = "sha256-F6XRZFVIN6/HfcM8yI/PyNke45FL7jbcznIiqj22eIQ=";
    };
  };

  patches = [
    ./swagger-cli.patch
    ./run.go.config.proto.patch
    ./run.python3.config.proto.patch
    ./run.bash.config.proto.patch
  ];

  postPatch = ''
    substituteInPlace windmill-worker/src/worker.rs \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'

    substituteInPlace windmill-api/src/lib.rs \
      --replace 'unknown-version' 'v${version}'

    substituteInPlace src/main.rs \
      --replace 'unknown-version' 'v${version}'
  '';

  buildInputs = [ openssl rustfmt lld ];

  nativeBuildInputs = [ pkg-config makeWrapper swagger-cli ];

  preBuild = ''
    pushd ..

    mkdir -p frontend/build

    cp -R ${frontend-build}/share/windmill-frontend/* frontend/build
    cp ${fullSrc}/openflow.openapi.yaml .

    popd
  '';

  # needs a postgres database running
  doCheck = false;

  postFixup = ''
    patchelf --set-rpath ${lib.makeLibraryPath [openssl]} $out/bin/windmill

    wrapProgram "$out/bin/windmill" \
      --prefix PATH : ${lib.makeBinPath [go pythonEnv deno nsjail bash]} \
      --set PYTHON_PATH "${pythonEnv}/bin/python3" \
      --set GO_PATH "${go}/bin/go" \
      --set DENO_PATH "${deno}/bin/deno" \
      --set NSJAIL_PATH "${nsjail}/bin/nsjail"
  '';

  meta = with lib; {
    description = "Open-source web IDE, scalable runtime and platform for serverless, workflows and UIs";
    homepage = "https://windmill.dev";
    license = licenses.agpl3;
    maintainers = with maintainers; [ dit7ya ];
    # limited by librusty_v8
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
