{ piper-tts
, python3
}:

let
  python = python3.override {
    packageOverrides = self: super: {
    };
  };
in

python.pkgs.buildPythonPackage {
  inherit (piper-tts) version src;

  pname = "piper-train";
  format = "setuptools";

  sourceRoot = "${piper-tts.src.name}/src/python";

  nativeBuildInputs = with python.pkgs; [
    cython
  ];

  postBuild = ''
    make -C piper_train/vits/monotonic_align
  '';

  postInstall = ''
    export MONOTONIC_ALIGN=$out/${python.sitePackages}/piper_train/vits/monotonic_align/monotonic_align
    mkdir -p $MONOTONIC_ALIGN
    cp -v ./piper_train/vits/monotonic_align/piper_train/vits/monotonic_align/core.*.so $MONOTONIC_ALIGN/
  '';

  propagatedBuildInputs = with python.pkgs; [
    espeak-phonemizer
    librosa
    numpy
    onnxruntime
    piper-phonemize
    pytorch-lightning
    torch
  ];

  pythonImportsCheck = [
    "piper_train"
  ];

  doCheck = false; # no tests

  meta = piper-tts.meta // {
    # requires torch<2, pytorch-lightning~=1.7
    broken = true;
  };
}
