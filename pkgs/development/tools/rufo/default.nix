{ bundlerApp, bundlerUpdateScript, lib }:

bundlerApp {
  pname = "rufo";
  gemdir = ./.;
  exes = [ "rufo" ];

  passthru.updateScript = bundlerUpdateScript "rufo";

  meta = with lib; {
    description = "Ruby formatter";
    homepage = "https://github.com/ruby-formatter/rufo";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
<<<<<<< HEAD
    mainProgram = "rufo";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
