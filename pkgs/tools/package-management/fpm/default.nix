{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "fpm";
  gemdir = ./.;
  exes = [ "fpm" ];

  passthru.updateScript = bundlerUpdateScript "fpm";

<<<<<<< HEAD
  meta = {
    description = "Tool to build packages for multiple platforms with ease";
    homepage = "https://github.com/jordansissel/fpm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manveru
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool to build packages for multiple platforms with ease";
    homepage = "https://github.com/jordansissel/fpm";
    license = licenses.mit;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "fpm";
  };
}
