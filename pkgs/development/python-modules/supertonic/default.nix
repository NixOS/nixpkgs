{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  setuptools,
  wheel,
  onnxruntime,
  numpy,
  soundfile,
  huggingface-hub,
  sounddevice,
  fastapi,
  uvicorn,
  pydantic,
  python-multipart,
  curl,
  pytest,
  testers,
  pythonOlder,
}:

let
  model = import ./model.nix { inherit fetchurl runCommand; };
in

buildPythonPackage (finalAttrs: {
  pname = "supertonic";
  version = "1.3.1";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "supertone-inc";
    repo = "supertonic-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FEs511UjMTkgDptxDuBNUTkhTwuv/vp3R3cDfApsNKA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    fastapi
    huggingface-hub
    numpy
    onnxruntime
    pydantic
    python-multipart
    soundfile
    uvicorn
  ];

  optional-dependencies = {
    playback = [ sounddevice ];
  };

  pythonImportsCheck = [ "supertonic" ];

  passthru = {
    # Pre-fetched supertonic-3 model weights.  Usage:
    #   SUPERTONIC_CACHE_DIR=${python3Packages.supertonic.model} supertonic tts ...
    inherit model;

    tests = {
      # Verify `supertonic version` reports the expected version string.
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "supertonic version";
      };

      pytest =
        runCommand "supertonic-pytest"
          {
            src = finalAttrs.src;
            nativeBuildInputs = [
              finalAttrs.finalPackage
              pytest
            ];
          }
          ''
            unpackPhase
            export HOME=$(mktemp -d)
            export SUPERTONIC_CACHE_DIR=${model}
            pytest
            touch "$out"
          '';

      # Synthesise a short phrase and check that a non-empty WAV is written.
      basic-tts =
        runCommand "supertonic-basic-tts"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            export SUPERTONIC_CACHE_DIR=${model}
            export HOME=$(mktemp -d)
            supertonic tts "Hello, Nix!" -o "$TMPDIR/out.wav"
            test -s "$TMPDIR/out.wav"
            touch "$out"
          '';

      # Confirm all ten built-in voice styles are reported by list-voices.
      list-voices =
        runCommand "supertonic-list-voices"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            export SUPERTONIC_CACHE_DIR=${model}
            export HOME=$(mktemp -d)
            voices=$(supertonic list-voices)
            for v in F1 F2 F3 F4 F5 M1 M2 M3 M4 M5; do
              echo "$voices" | grep -q "$v"
            done
            touch "$out"
          '';

      # Start the HTTP server and exercise /v1/health and /v1/tts.
      serve =
        runCommand "supertonic-serve"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              curl
            ];
          }
          ''
            export SUPERTONIC_CACHE_DIR=${model}
            export HOME=$(mktemp -d)
            PORT=7789

            supertonic serve --port "$PORT" --log-level warning \
              >"$TMPDIR/serve.log" 2>&1 &
            SERVER_PID=$!
            trap 'kill "$SERVER_PID" 2>/dev/null || true; wait "$SERVER_PID" 2>/dev/null || true' EXIT

            # Poll /v1/health until the model finishes loading (up to 90 s).
            for i in $(seq 1 90); do
              if curl -sf "http://127.0.0.1:$PORT/v1/health" | grep -q '"status":"ok"'; then
                break
              fi
              sleep 1
            done
            curl -sf "http://127.0.0.1:$PORT/v1/health" | grep -q '"status":"ok"'

            # Synthesise speech via the REST API and verify non-empty audio.
            curl -sf -X POST "http://127.0.0.1:$PORT/v1/tts" \
              -H "Content-Type: application/json" \
              -d '{"text":"Hello, Nix!","voice":"M1"}' \
              -o "$TMPDIR/serve-out.wav"
            test -s "$TMPDIR/serve-out.wav"

            touch "$out"
          '';
    };
  };

  meta = {
    description = "Lightning-fast on-device multilingual TTS via ONNX Runtime";
    longDescription = ''
      Supertonic is a 99M-parameter open-weight text-to-speech system that runs
      fully on-device via ONNX Runtime — no GPU, cloud service, or API key
      required.  It supports 31 languages, produces 44.1 kHz audio, and exposes
      both a Python API and a CLI.

      The model weights are downloaded from Hugging Face Hub on first use and
      are governed by the Open RAIL-M licence rather than the MIT licence that
      covers the Python code packaged here.  Pre-fetched weights are available
      via passthru.model.
    '';
    homepage = "https://github.com/supertone-inc/supertonic";
    changelog = "https://github.com/supertone-inc/supertonic-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "supertonic";
    maintainers = with lib.maintainers; [ io12 ];
  };
})
