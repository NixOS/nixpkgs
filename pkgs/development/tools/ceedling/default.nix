{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "ceedling";
  gemdir = ./.;
  exes = [ "ceedling" ];

<<<<<<< HEAD
  meta = {
    description = "Build system for C projects that is something of an extension around Ruby's Rake";
    homepage = "https://www.throwtheswitch.org/ceedling";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.rlwrnc ];
=======
  meta = with lib; {
    description = "Build system for C projects that is something of an extension around Ruby's Rake";
    homepage = "https://www.throwtheswitch.org/ceedling";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.rlwrnc ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ceedling";
  };
}
