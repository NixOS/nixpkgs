{ lib, makeWrapper, haskellngPackages
, mueval
, withDjinn ? true
, aspell ? null
, packages ? (pkgs: [])
, modules ? ''
    haskellPlugins
    ++ ["irc", "localtime", "topic"]
    ++ ["dummy", "fresh", "todo"]
    ++ ["bf", "dice", "elite", "filter", "quote", "slap", "unlambda", "vixen"]
    ++ referencePlugins
    ++ socialPlugins
''
, configuration ? "[]"
}:

# FIXME: fix hoogle search

let allPkgs = pkgs: mueval.defaultPkgs pkgs ++ [ pkgs.lambdabot-trusted ] ++ packages pkgs;
    mueval' = mueval.override {
      inherit haskellngPackages;
      packages = allPkgs;
    };
    bins = lib.makeSearchPath "bin" ([ mueval'
                                       (haskellngPackages.ghcWithPackages allPkgs)
                                       haskellngPackages.unlambda
                                       haskellngPackages.brainfuck
                                     ]
                                     ++ lib.optional withDjinn haskellngPackages.djinn
                                     ++ lib.optional (aspell != null) aspell
                                    );
    modulesStr = lib.replaceChars ["\n"] [" "] ("corePlugins ++ " + modules);
    configStr = lib.replaceChars ["\n"] [" "] configuration;

in lib.overrideDerivation haskellngPackages.lambdabot (self: {
  postPatch = (self.postPatch or "") + ''
    sed -i 's/\(\$(modules \$ \).*/\1@modules@)/; /@modules@/q' src/Modules.hs
    # not via sed to avoid escaping issues
    substituteInPlace src/Modules.hs \
      --replace '@modules@' '${modulesStr}'
    sed -i 's/\[dataDir :=> dir\]/@config@ ++ \0/' src/Main.hs
    substituteInPlace src/Main.hs \
      --replace '@config@' '${configStr}'
  '';

  buildInputs = self.buildInputs ++ [ makeWrapper ];

  postInstall = (self.postInstall or "") + lib.optionalString (bins != "") ''
    wrapProgram $out/bin/lambdabot \
      --prefix PATH ":" '${bins}'
  '';
})
