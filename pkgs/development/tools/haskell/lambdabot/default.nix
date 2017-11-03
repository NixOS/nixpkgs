{ lib, haskellLib, fetchpatch, makeWrapper, haskellPackages
, mueval
, withDjinn ? true
, aspell ? null
, packages ? (pkgs: [])
, modules ? "oldDefaultModules"
, configuration ? "[]"
}:

# FIXME: fix hoogle search

let allPkgs = pkgs: mueval.defaultPkgs pkgs ++ [ pkgs.lambdabot-trusted ] ++ packages pkgs;
    mueval' = mueval.override {
      inherit haskellPackages;
      packages = allPkgs;
    };
    bins = lib.makeBinPath ([ mueval'
                              (haskellPackages.ghcWithPackages allPkgs)
                              haskellPackages.unlambda
                              haskellPackages.brainfuck
                            ]
                            ++ lib.optional withDjinn haskellPackages.djinn
                            ++ lib.optional (aspell != null) aspell
                           );
    modulesStr = lib.replaceChars ["\n"] [" "] modules;
    configStr = lib.replaceChars ["\n"] [" "] configuration;

in haskellLib.overrideCabal haskellPackages.lambdabot (self: {
  patches = (self.patches or []) ++ [ ./custom-config.patch ];
  postPatch = (self.postPatch or "") + ''
    substituteInPlace src/Main.hs \
      --replace '@config@' '${configStr}'
    substituteInPlace src/Modules.hs \
      --replace '@modules@' '${modulesStr}'
  '';

  buildTools = (self.buildTools or []) ++ [ makeWrapper ];

  postInstall = (self.postInstall or "") + ''
    wrapProgram $out/bin/lambdabot \
      --prefix PATH ":" '${bins}'
  '';
})
