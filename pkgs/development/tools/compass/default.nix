{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "compass";
  version = "1.0.3";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "compass";

<<<<<<< HEAD
  meta = {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage = "https://github.com/Compass/compass";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage = "https://github.com/Compass/compass";
    license = with licenses; mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      offline
      manveru
      nicknovitski
    ];
    mainProgram = "compass";
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
