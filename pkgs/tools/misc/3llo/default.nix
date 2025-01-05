{ lib, bundlerApp }:

bundlerApp {
  pname = "3llo";

  gemdir = ./.;

  exes = [ "3llo" ];

  meta = with lib; {
    description = "Trello interactive CLI on terminal";
    license = licenses.mit;
    homepage = "https://github.com/qcam/3llo";
    maintainers = [ ];
  };
}
