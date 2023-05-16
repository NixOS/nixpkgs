{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
<<<<<<< HEAD
, zig_0_10
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linuxwave";
  version = "0.1.5";
=======
, zig
}:

stdenv.mkDerivation rec {
  pname = "linuxwave";
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "linuxwave";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-5c8h9bAe3Qv7PJ3PPcwMJYKPlWsmnqshe6vLIgtdDiQ=";
=======
    rev = "v${version}";
    hash = "sha256-e+QTteyHAyYmU4vb86Ju92DxNFFX01g/rsViNI5ba1s=";
    fetchSubmodules = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    installShellFiles
<<<<<<< HEAD
    zig_0_10.hook
  ];

  postInstall = ''
    installManPage man/linuxwave.1
  '';

  meta = {
    homepage = "https://github.com/orhun/linuxwave";
    description = "Generate music from the entropy of Linux";
    changelog = "https://github.com/orhun/linuxwave/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    inherit (zig_0_10.meta) platforms;
  };
})
=======
    zig
  ];

  postConfigure = ''
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  buildPhase = ''
    runHook preBuild

    zig build -Drelease-safe -Dcpu=baseline

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    zig build test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    zig build -Drelease-safe -Dcpu=baseline --prefix $out install

    installManPage man/linuxwave.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Generate music from the entropy of Linux";
    homepage = "https://github.com/orhun/linuxwave";
    changelog = "https://github.com/orhun/linuxwave/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
