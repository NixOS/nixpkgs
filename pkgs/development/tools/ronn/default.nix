{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper, groff, callPackage }:

stdenv.mkDerivation rec {
  pname = "ronn";
  version = env.gems.ronn-ng.version;

  env = bundlerEnv {
    name = "ronn-gems";
    gemdir = ./.;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${env}/bin/ronn $out/bin/ronn \
      --set PATH ${groff}/bin

    runHook postInstall
  '';

  passthru.updateScript = bundlerUpdateScript "ronn";

  passthru.tests.reproducible-html-manpage = callPackage ./test-reproducible-html.nix { };

  meta = with lib; {
    description = "markdown-based tool for building manpages";
    mainProgram = "ronn";
    homepage = "https://github.com/apjanke/ronn-ng";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm nicknovitski ];
    platforms = env.ruby.meta.platforms;
  };
}
