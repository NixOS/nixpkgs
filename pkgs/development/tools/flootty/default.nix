{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "Flootty";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B8YxhL94YkEBa04HTXDRme/rQfYh0cpyrTcgTwcJ1D0=";
  };

  meta = with lib; {
    description = "Collaborative terminal. In practice, it's similar to a shared screen or tmux session";
    mainProgram = "flootty";
    homepage = "https://floobits.com/help/flootty";
    license = licenses.asl20;
    maintainers = with maintainers; [ sellout ];
  };
}
