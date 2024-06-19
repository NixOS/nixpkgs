{ lib
, stdenv
, fetchFromGitHub
, zig_0_12
, callPackage
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zls";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "zigtools";
    repo = "zls";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-2iVDPUj9ExgTooDQmCCtZs3wxBe2be9xjzAk9HedPNY=";
  };

  zigBuildFlags = [
    "-Dversion_data_path=${zig_0_12.src}/doc/langref.html.in"
  ];

  nativeBuildInputs = [
    zig_0_12.hook
  ];

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  meta = {
    description = "Zig LSP implementation + Zig Language Server";
    mainProgram = "zls";
    changelog = "https://github.com/zigtools/zls/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zigtools/zls";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda moni ];
    platforms = lib.platforms.unix;
  };
})
