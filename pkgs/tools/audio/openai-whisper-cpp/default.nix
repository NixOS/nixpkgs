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
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "whisper.cpp";
    rev = "refs/tags/v${finalAttrs.version}" ;
    hash = "sha256-9H2Mlua5zx2WNXbz2C5foxIteuBgeCNALdq5bWyhQCk=";
  };

  # The upstream download script tries to download the models to the
  # directory of the script, which is not writable due to being
  # inside the nix store. This patch changes the script to download
  # the models to the current directory of where it is being run from.
  patches = [ ./download-models.patch ];

  nativeBuildInputs = [
      which
      makeWrapper
    ] ++ lib.optionals cudaSupport ( with cudaPackages ;[
      cuda_nvcc

      autoAddDriverRunpath
    ]);

  buildInputs = [
      SDL2
    ] ++ lib.optionals stdenv.isDarwin [
      Accelerate
      CoreGraphics
      CoreML
      CoreVideo
      MetalKit
    ] ++ lib.optionals cudaSupport ( with cudaPackages; [

      # A temporary hack for reducing the closure size, remove once cudaPackages
      # have stopped using lndir: https://github.com/NixOS/nixpkgs/issues/271792
      cuda_cccl.dev # provides nv/target
      cuda_cudart.dev
      cuda_cudart.lib
      cuda_cudart.static
      libcublas.dev
      libcublas.lib
      libcublas.static
    ]);

  postPatch = let
    cudaOldStr = "-lcuda ";
    cudaNewStr = "-lcuda -L${cudaPackages.cuda_cudart.lib}/lib/stubs ";
  in lib.optionalString cudaSupport ''
    substituteInPlace Makefile \
      --replace '${cudaOldStr}' '${cudaNewStr}'
  '';

  env = lib.optionalAttrs stdenv.isDarwin {
    WHISPER_COREML = "1";
    WHISPER_COREML_ALLOW_FALLBACK = "1";
  } // lib.optionalAttrs cudaSupport {
    WHISPER_CUBLAS = "1";
  };

  makeFlags = [ "main" "stream" "command" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./main $out/bin/whisper-cpp
    cp ./stream $out/bin/whisper-cpp-stream
    cp ./command $out/bin/whisper-cpp-command

    cp models/download-ggml-model.sh $out/bin/whisper-cpp-download-ggml-model

    wrapProgram $out/bin/whisper-cpp-download-ggml-model \
      --prefix PATH : ${lib.makeBinPath [wget]}

    ${lib.optionalString stdenv.isDarwin ''
      install -Dt $out/share/whisper-cpp ggml-metal.metal

      for bin in whisper-cpp whisper-cpp-stream whisper-cpp-command; do
        wrapProgram $out/bin/$bin \
          --set-default GGML_METAL_PATH_RESOURCES $out/share/whisper-cpp
      done
    ''}

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
