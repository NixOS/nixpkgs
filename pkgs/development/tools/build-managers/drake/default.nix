{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "drake";
  gemdir = ./.;
  exes = [ "drake" ];

  passthru.updateScript = bundlerUpdateScript "drake";

<<<<<<< HEAD
  meta = {
    description = "Branch of Rake supporting automatic parallelizing of tasks";
    homepage = "http://quix.github.io/rake/";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Branch of Rake supporting automatic parallelizing of tasks";
    homepage = "http://quix.github.io/rake/";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      romildo
      manveru
      nicknovitski
    ];
<<<<<<< HEAD
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
    license = licenses.mit;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
