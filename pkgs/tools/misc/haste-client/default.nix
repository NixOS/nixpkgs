{ lib
, bundlerApp
<<<<<<< HEAD
}:

bundlerApp {
=======
, buildRubyGem
, ruby
}:

bundlerApp rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "haste";
  gemdir = ./.;
  exes = [ "haste" ];

  meta = with lib; {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage    = "https://rubygems.org/gems/haste";
    license     = licenses.mit;
    maintainers = with maintainers; [ shamilton ];
    platforms   = platforms.unix;
  };
}
