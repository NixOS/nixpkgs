{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "solargraph";
  exes = [ "solargraph" ];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "solargraph";

  meta = with lib; {
    description = "A Ruby language server";
    homepage = "https://solargraph.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace nicknovitski angristan ];
  };
}
