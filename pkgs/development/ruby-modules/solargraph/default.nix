{ lib, defaultGemConfig, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "solargraph";
  exes = ["solargraph"  "solargraph-runtime"];
  gemdir = ./.;

  # Solargraph tries to analyze the active bundle, but bundlerApp creates a bundle.
  # This patch hacks it to look at the original bundle instead.
  gemConfig = defaultGemConfig // {
    solargraph = attrs: {
      patches = [ ./0001-Analyze-original-bundle-rather-than-solargraph-s.patch ];
      dontBuild = false;
    };
  };

  passthru.updateScript = bundlerUpdateScript "solargraph";

  meta = with lib; {
    description = "IDE tools for the Ruby language";
    homepage = http://www.github.com/castwide/solargraph;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace nicknovitski angristan ];
    platforms = platforms.unix;
  };
}
