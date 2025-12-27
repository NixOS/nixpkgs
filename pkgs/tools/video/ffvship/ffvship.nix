{
  lib,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  ffms,
  ffmpeg-headless,
  vship,
  gpuBackend ? "rocm",
}:
# ffvship needs a valid GPU backend
assert builtins.elem gpuBackend [
  "cuda"
  "rocm"
];
clangStdenv.mkDerivation (finalAttrs: {
  pname = "ffvship";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "Line-fr";
    repo = "Vship";
    tag = "v${finalAttrs.version}";
    hash = "sha256-enRdz0oryvERGYKpymKJLmtxThXR0NFkiinvkNAVxi0=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ffms
    ffmpeg-headless
    vship.${gpuBackend}
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = "buildFFVSHIP";

  meta = {
    description = "CLI for Vship";
    homepage = "https://github.com/Line-fr/Vship";
    changelog = "https://github.com/Line-fr/Vship/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      armelclo
    ];
    platforms = lib.platforms.linux;
    mainProgram = "FFVship";
  };
})
