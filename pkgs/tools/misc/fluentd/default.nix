{
  lib,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerEnv {
  inherit ruby;

  pname = "fluentd";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "fluentd";
  passthru.tests.fluentd = nixosTests.fluentd;

<<<<<<< HEAD
  meta = {
    description = "Data collector";
    homepage = "https://www.fluentd.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      nicknovitski
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Data collector";
    homepage = "https://www.fluentd.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [
      offline
      nicknovitski
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
