<<<<<<< HEAD
{ lib, bundlerApp }:

bundlerApp {
  pname = "3llo";
=======
{ lib, ruby_3_0, bundlerApp, fetchpatch }:

bundlerApp {
  pname = "3llo";
  ruby = ruby_3_0;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  gemdir  = ./.;

  exes = [ "3llo" ];

  meta = with lib; {
    description = "Trello interactive CLI on terminal";
    license = licenses.mit;
    homepage = "https://github.com/qcam/3llo";
    maintainers = with maintainers; [ ];
  };
}
