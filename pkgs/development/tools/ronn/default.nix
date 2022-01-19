{ stdenv, lib, bundlerEnv, bundlerUpdateScript, makeWrapper, groff, callPackage }:

stdenv.mkDerivation rec {
  pname = "ronn";
  version = env.gems.ronn.version;

  env = bundlerEnv {
    name = "ronn-gems";
    gemdir = ./.;
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${env}/bin/ronn $out/bin/ronn \
      --set PATH ${groff}/bin
  '';

  passthru.updateScript = bundlerUpdateScript "ronn";

  passthru.tests.reproducible-html-manpage = callPackage ./test-reproducible-html.nix { };

  meta = with lib; {
    description = "markdown-based tool for building manpages";
    homepage = "https://rtomayko.github.io/ronn/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm nicknovitski ];
    platforms = env.ruby.meta.platforms;
  };
}
