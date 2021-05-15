{ lib, stdenv, fetchFromGitHub
, pkg-config, addOpenGLRunpath
, sha256, cudatoolkit
}:

let
  pname = "cuda-samples";
  version = lib.versions.majorMinor cudatoolkit.version;
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    inherit sha256;
  };

  nativeBuildInputs = [ pkg-config addOpenGLRunpath ];

  buildInputs = [ cudatoolkit ];

  enableParallelBuilding = true;

  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/${stdenv.hostPlatform.parsed.cpu.name}/${stdenv.hostPlatform.parsed.kernel.name}/release/*

    runHook postInstall
  '';

  postFixup = ''
    for exe in $out/bin/*; do
      addOpenGLRunpath $exe
    done
  '';

  meta = {
    description = "Samples for CUDA Developers which demonstrates features in CUDA Toolkit";
    # CUDA itself is proprietary, but these sample apps are not.
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ];
  };
}
