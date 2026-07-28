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

  meta = {
    description = "Branch of Rake supporting automatic parallelizing of tasks";
    homepage = "http://quix.github.io/rake/";
    maintainers = with lib.maintainers; [
      romildo
      nicknovitski
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
