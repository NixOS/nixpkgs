{ addOpenGLRunpath
, cudatoolkit
, fetchFromGitHub
, fetchpatch
, lib
, pkg-config
, sha256
, stdenv
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

  # See https://github.com/NVIDIA/cuda-samples/issues/75.
  patches = lib.optionals (version == "11.3") [
    (fetchpatch {
      url = "https://github.com/NVIDIA/cuda-samples/commit/5c3ec60faeb7a3c4ad9372c99114d7bb922fda8d.patch";
      sha256 = "sha256:15bydf59scmfnldz5yawbjacdxafi50ahgpzq93zlc5xsac5sz6i";
    })
  ];

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
