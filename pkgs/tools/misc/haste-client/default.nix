{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "haste";
  gemdir = ./.;
  exes = [ "haste" ];

<<<<<<< HEAD
  meta = {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://rubygems.org/gems/haste";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://rubygems.org/gems/haste";
    license = licenses.mit;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "haste";
  };
}
