{ lib
, pkgs
, buildNpmPackage
, fetchFromGitHub
, fetchPypi
, python
, nodejs
, nixosTests
# build-time deps
, pkg-config
, makeWrapper
, cmake
# runtime deps
, ffmpeg
, imagemagick
, libraw
, vips
}:
let
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    rev = "v${version}";
    inherit (sources) hash;
  };

  cli = buildNpmPackage' {
    pname = "immich-cli";
    inherit version;
    src = "${src}/cli";
    inherit (sources.components.cli) npmDepsHash;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      npm config delete cache
      npm prune --omit=dev --omit=optional

      mkdir -p $out
      mv package.json package-lock.json node_modules dist $out/

      makeWrapper ${nodejs}/bin/node $out/bin/cli --add-flags $out/dist/index.js

      runHook postInstall
    '';
  };

  web = buildNpmPackage' {
    pname = "immich-web";
    inherit version;
    src = "${src}/web";
    inherit (sources.components.web) npmDepsHash;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      npm config delete cache
      npm prune --omit=dev --omit=optional

      mkdir -p $out
      mv package.json package-lock.json node_modules build $out/

      makeWrapper ${nodejs}/bin/node $out/bin/web --add-flags $out/build/index.js

      runHook postInstall
    '';
  };

  # TODO should be converted to top-level package
  open-clip-torch = python.pkgs.buildPythonApplication rec {
    pname = "open-clip-torch";
    version = "2.20.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "mlfoundations";
      repo = "open_clip";
      rev = "v${version}";
      hash = "sha256-Ca4oi2LqleIFAGBJB7YIi4nXe2XhOP6ErDFXgXtJLxM=";
    };

    nativeBuildInputs = [
      python.pkgs.setuptools
      python.pkgs.wheel
    ];

    propagatedBuildInputs = with python.pkgs; [
      ftfy
      huggingface-hub
      protobuf
      regex
      sentencepiece
      timm
      torch
      torchvision
      tqdm
    ];

    pythonImportsCheck = [ "open_clip" ];

    meta = with lib; {
      description = "An open source implementation of CLIP";
      homepage = "https://github.com/mlfoundations/open_clip";
      license = licenses.mit;
      maintainers = with maintainers; [ oddlama ];
      mainProgram = "open-clip-torch";
    };
  };

  # TODO should be converted to top-level package
  clip-server = python.pkgs.buildPythonApplication rec {
    pname = "clip-server";
    version = "0.8.2";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-yhBLXqbV3U1JAGPlfih1bxxBzATHzyGQdNVGKI4DKg8=";
    };

    nativeBuildInputs = [
      python.pkgs.setuptools
      python.pkgs.wheel
    ];

    pythonImportsCheck = [ "clip_server" ];

    meta = with lib; {
      description = "Embed images and sentences into fixed-length vectors via CLIP";
      homepage = "https://pypi.org/project/clip-server/";
      license = licenses.asl20;
      maintainers = with maintainers; [ oddlama ];
      mainProgram = "clip-server";
    };
  };

  machine-learning = python.pkgs.buildPythonApplication {
    pname = "immich-machine-learning";
    inherit version;
    src = "${src}/machine-learning";
    format = "pyproject";

    postPatch = ''
      rm poetry.lock

      # opencv is named differently, also remove development dependencies not needed at runtime
      substituteInPlace pyproject.toml \
        --replace 'opencv-python-headless = "^4.7.0.72"' "" \
        --replace 'pydantic = "^1.10.8"' ""

      # XXX: Remove these once nix packages reach compatible versions
      substituteInPlace pyproject.toml \
        --replace 'pillow = "^9.5.0"' 'pillow = "^10.0.0"'

      # XXX: These can be removed once opencv4 reaches 4.8.0
      substituteInPlace app/models/facial_recognition.py \
        --replace ": cv2.Mat" ""
      substituteInPlace app/test_main.py \
        --replace ": cv2.Mat" ""
      substituteInPlace app/main.py \
        --replace ": cv2.Mat" "" \
        --replace "-> cv2.Mat" ""
    '';

    nativeBuildInputs = with python.pkgs; [
      pythonRelaxDepsHook
      poetry-core
      cython
      makeWrapper
    ];

    propagatedBuildInputs = with python.pkgs; [
      aiocache
      fastapi
      optimum
      torchvision
      rich
      ftfy
      open-clip-torch
      clip-server
      python-multipart
      orjson
      safetensors
      gunicorn
      insightface
      onnxruntime
      opencv4
      pillow
      sentence-transformers
      torch
      transformers
      uvicorn
    ] ++ python.pkgs.uvicorn.optional-dependencies.standard;

    nativeCheckInputs = with python.pkgs; [
      pytestCheckHook
      pytest-asyncio
      pytest-mock
    ];

    postInstall = ''
      mkdir -p $out/share
      cp log_conf.json $out/share
      makeWrapper ${python.pkgs.gunicorn}/bin/gunicorn $out/bin/machine-learning \
        --prefix PYTHONPATH : "$PYTHONPATH" \
        --add-flags "app.main:app -k uvicorn.workers.UvicornWorker \
          -w \"\$MACHINE_LEARNING_WORKERS\" \
          -b \"\$MACHINE_LEARNING_HOST:\$MACHINE_LEARNING_PORT\" \
          -t \"\$MACHINE_LEARNING_WORKER_TIMEOUT\" \
          --log-config-json $out/share/log_conf.json"
    '';

    preCheck = ''
      export TRANSFORMERS_CACHE=/tmp
    '';

    passthru = {
      inherit python;
    };
  };
in
buildNpmPackage' {
  pname = "immich";
  inherit version;
  src = "${src}/server";
  inherit (sources.components.server) npmDepsHash;

  nativeBuildInputs = [
    pkg-config
    python
    makeWrapper
  ];

  buildInputs = [
    ffmpeg
    imagemagick
    libraw
    vips # Required for sharp
  ];

  # Required because vips tries to write to the cache dir
  makeCacheWritable = true;
  # TODO not working prePatch = ''
  # TODO not working   export npm_config_libvips_local_prebuilds="/tmp"
  # TODO not working '';

  installPhase = ''
    runHook preInstall

    npm config delete cache
    npm prune --omit=dev --omit=optional

    mkdir -p $out
    mv package.json package-lock.json node_modules dist $out/

    makeWrapper ${nodejs}/bin/node $out/bin/admin-cli --add-flags $out/dist/main --add-flags cli
    makeWrapper ${nodejs}/bin/node $out/bin/microservices --add-flags $out/dist/main --add-flags microservices
    makeWrapper ${nodejs}/bin/node $out/bin/server --add-flags $out/dist/main --add-flags immich

    runHook postInstall
  '';

  passthru = {
    inherit cli web machine-learning;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Self-hosted photo and video backup solution";
    homepage = "https://immich.app/";
    license = licenses.mit;
    maintainers = with maintainers; [ oddlama ];
    inherit (nodejs.meta) platforms;
  };
}
