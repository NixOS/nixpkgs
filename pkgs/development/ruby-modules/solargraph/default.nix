{ lib, bundlerApp }:

bundlerApp rec {
  pname = "solargraph";
  exes = ["solargraph"  "solargraph-runtime"];
  gemdir = ./.;

  meta = with lib; {
    description = "IDE tools for the Ruby language";
    homepage = http://www.github.com/castwide/solargraph;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.unix;
  };
}
