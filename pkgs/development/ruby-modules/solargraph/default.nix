{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp rec {
  pname = "solargraph";
  exes = ["solargraph"  "solargraph-runtime"];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "solargraph";

  meta = with lib; {
    description = "IDE tools for the Ruby language";
    homepage = http://www.github.com/castwide/solargraph;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace nicknovitski ];
    platforms = platforms.unix;
  };
}
