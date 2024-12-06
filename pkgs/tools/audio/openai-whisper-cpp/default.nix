{ lib
, stdenv
, fetchFromGitHub
, SDL2
, makeWrapper
, wget
, which
, Accelerate
, CoreGraphics
, CoreML
, CoreVideo
, MetalKit

, config
, autoAddDriverRunpath
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
}:

let
  # It's necessary to consistently use backendStdenv when building with CUDA support,
  # otherwise we get libstdc++ errors downstream.
  # cuda imposes an upper bound on the gcc version, e.g. the latest gcc compatible with cudaPackages_11 is gcc11
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "whisper-cpp";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "whisper.cpp";
    rev = "refs/tags/v${finalAttrs.version}" ;
    hash = "sha256-y30ZccpF3SCdRGa+P3ddF1tT1KnvlI4Fexx81wZxfTk=";
  };

  # The upstream download script tries to download the models to the
  # directory of the script, which is not writable due to being
  # inside the nix store. This patch changes the script to download
  # the models to the current directory of where it is being run from.
  patches = [ ./download-models.patch ];

  nativeBuildInputs = [
      which
      makeWrapper
    ] ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ];

  buildInputs = [
      SDL2
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Accelerate
      CoreGraphics
      CoreML
      CoreVideo
      MetalKit
    ] ++ lib.optionals cudaSupport ( with cudaPackages; [
      cuda_cccl # provides nv/target
      cuda_cudart
      libcublas
    ]);

  postPatch = let
    cudaOldStr = "-lcuda ";
    cudaNewStr = "-lcuda -L${cudaPackages.cuda_cudart}/lib/stubs ";
  in lib.optionalString cudaSupport ''
    substituteInPlace Makefile \
      --replace-fail '${cudaOldStr}' '${cudaNewStr}'
  '';

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    WHISPER_COREML = "1";
    WHISPER_COREML_ALLOW_FALLBACK = "1";
    WHISPER_METAL_EMBED_LIBRARY = "1";
  } // lib.optionalAttrs cudaSupport {
    GGML_CUDA = "1";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp ./main $out/bin/whisper-cpp

    for file in *; do
      if [[ -x "$file" && -f "$file" && "$file" != "main" ]]; then
        cp "$file" "$out/bin/whisper-cpp-$file"
      fi
    done

    cp models/download-ggml-model.sh $out/bin/whisper-cpp-download-ggml-model

    wrapProgram $out/bin/whisper-cpp-download-ggml-model \
      --prefix PATH : ${lib.makeBinPath [wget]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Port of OpenAI's Whisper model in C/C++";
    longDescription = ''
      To download the models as described in the project's readme, you may
      use the `whisper-cpp-download-ggml-model` binary from this package.
    '';
    homepage = "https://github.com/ggerganov/whisper.cpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ dit7ya hughobrien ];
  };
})
