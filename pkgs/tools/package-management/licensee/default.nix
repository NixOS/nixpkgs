{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "licensee";
  gemdir = ./.;
  exes = [ "licensee" ];

  passthru.updateScript = bundlerUpdateScript "licensee";

<<<<<<< HEAD
  meta = {
    description = "Ruby Gem to detect under what license a project is distributed";
    homepage = "https://licensee.github.io/licensee/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Ruby Gem to detect under what license a project is distributed";
    homepage = "https://licensee.github.io/licensee/";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "licensee";
  };
}
