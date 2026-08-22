{ fetchurl, runCommand }:

let
  # Pinned HuggingFace revision for supertonic-3 — matches MODEL_CONFIGS in
  # supertonic/config.py so this derivation and the runtime download path use
  # the same commit.
  modelRev = "724fb5abbf5502583fb520898d45929e62f02c0b";
  modelBase = "https://huggingface.co/Supertone/supertonic-3/resolve/${modelRev}";

  fetchModelFile =
    path: hash:
    fetchurl {
      url = "${modelBase}/${path}";
      inherit hash;
    };
in

# Pre-fetched supertonic-3 model weights assembled into the directory layout
# the loader expects.  Set SUPERTONIC_CACHE_DIR to point at this derivation to
# run the CLI offline.
#
# The model weights are distributed under the Open RAIL-M licence (use
# restrictions apply; see the LICENSE file in the HuggingFace repo).
runCommand "supertonic-3-model"
  {
    meta.license = {
      fullName = "Open RAIL-M License";
      url = "https://huggingface.co/Supertone/supertonic-3/blob/${modelRev}/LICENSE";
      free = false;
    };
  }
  ''
    mkdir -p "$out/onnx" "$out/voice_styles"

    # TTS graph config + unicode tokeniser
    ln -s ${fetchModelFile "onnx/tts.json" "sha256-QgeNOu8c1Dq0MCHzxU9H0tdc60519ifxGIkBKLBqDQk="} \
      "$out/onnx/tts.json"
    ln -s ${fetchModelFile "onnx/unicode_indexer.json" "sha256-m/c0bkOIOoH4ZFyBIk94bUPFtX82QfbnZxp9bEk8sk8="} \
      "$out/onnx/unicode_indexer.json"

    # ONNX model components (hashes verified against HuggingFace LFS metadata)
    ln -s ${fetchModelFile "onnx/duration_predictor.onnx" "sha256-w+uRQU1f+KeiObf+njTn4r+KgUDYN1/7FHGLHGOTJds="} \
      "$out/onnx/duration_predictor.onnx"
    ln -s ${fetchModelFile "onnx/text_encoder.onnx" "sha256-x779XqjDEZdp6KbBSGxO3Go7yDZcZ2IciBu7d0uZAv8="} \
      "$out/onnx/text_encoder.onnx"
    ln -s ${fetchModelFile "onnx/vector_estimator.onnx" "sha256-iDrIaOoCde8OmRUk3GTxazwDdu/XwyCva1P1t4DXxhw="} \
      "$out/onnx/vector_estimator.onnx"
    ln -s ${fetchModelFile "onnx/vocoder.onnx" "sha256-CF3nbdjo1YNtbKZoJmAfYVk5IY+Q5Rn3DuijbtKkxLo="} \
      "$out/onnx/vocoder.onnx"

    # Voice style presets (F1–F5 female, M1–M5 male)
    ln -s ${fetchModelFile "voice_styles/F1.json" "sha256-u97G7gAjHCx0KtBUg99TNMqztS/aO6OOagcFnEVj28I="} \
      "$out/voice_styles/F1.json"
    ln -s ${fetchModelFile "voice_styles/F2.json" "sha256-fHIsanJwexp38DXWfw0TUboYdzjgb3aD6McrHfNHf8Y="} \
      "$out/voice_styles/F2.json"
    ln -s ${fetchModelFile "voice_styles/F3.json" "sha256-EvbvJXO6ot76ESgGnLWfID46tnySr3e0Lfig46L3xqs="} \
      "$out/voice_styles/F3.json"
    ln -s ${fetchModelFile "voice_styles/F4.json" "sha256-wvp2TBIlp238Pixz6KpPcNnuSHk4YOs0wpX/8BwuAys="} \
      "$out/voice_styles/F4.json"
    ln -s ${fetchModelFile "voice_styles/F5.json" "sha256-RZZuczFkFWJs9Bp9HG87THDbwbor7lwZeO8M4zJE/I0="} \
      "$out/voice_styles/F5.json"
    ln -s ${fetchModelFile "voice_styles/M1.json" "sha256-41YEaH9dI2lLjpFZOpPuwOTspsCwK7jtaROasuprCls="} \
      "$out/voice_styles/M1.json"
    ln -s ${fetchModelFile "voice_styles/M2.json" "sha256-t2y/YrrHB8cQzwrlq6XjHuoaYzmpc0v64zq5hJlTSlA="} \
      "$out/voice_styles/M2.json"
    ln -s ${fetchModelFile "voice_styles/M3.json" "sha256-6hrDXMuRsNfsrVM6L70O7BDJFRPYlR47Jfu6mZVOFZs="} \
      "$out/voice_styles/M3.json"
    ln -s ${fetchModelFile "voice_styles/M4.json" "sha256-yo7vrU/NmJyTeQMv8+UHOK3FR+614iG4JZOm17O6wwM="} \
      "$out/voice_styles/M4.json"
    ln -s ${fetchModelFile "voice_styles/M5.json" "sha256-3SK5J0AxQyH4rhHF6H+N1g0GDxXdOmMrWt939HH3evI="} \
      "$out/voice_styles/M5.json"
  ''
