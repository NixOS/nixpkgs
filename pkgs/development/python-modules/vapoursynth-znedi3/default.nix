{
  lib,
  stdenv,
  toPythonModule,
  python,
  fetchFromGitHub,
  buildPythonPackage,
  vapoursynth,
}:

toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "vapoursynth-znedi3";
    version = "3.3";

    src = fetchFromGitHub {
      fetchSubmodules = true;
      owner = "sekrit-twc";
      repo = "znedi3";
      rev = "r${finalAttrs.version}";
      hash = "sha256-47QqqNkN1FuEaOrhhOOPFUGeXh2GJ3Vj35K271CFyoA=";
    };

    buildInputs = [ vapoursynth ];

    postPatch = ''
      ln -s $(vapoursynth get-include) vsxx/vapoursynth
    '';

    makeFlags = [
      "CPPFLAGS=-DNNEDI3_WEIGHTS_PATH='\"$(out)/share/nnedi3/nnedi3_weights.bin\"'"
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86 [
      "X86=1"
      "X86_AVX512=1"
    ];

    installPhase = ''
      runHook preInstall
      install -Dt "$out/${python.sitePackages}/vapoursynth/plugins" vsznedi3.so
      install -m644 -Dt "$out/share/nnedi3" nnedi3_weights.bin
      runHook postInstall
    '';

    meta = {
      inherit (vapoursynth.meta) platforms;
      description = "Filter for VapourSynth";
      homepage = "https://github.com/sekrit-twc/znedi3";
      license = with lib.licenses; [
        gpl2Plus
        wtfpl
        lgpl21
      ];
      maintainers = with lib.maintainers; [ snaki ];
    };
  })
)
