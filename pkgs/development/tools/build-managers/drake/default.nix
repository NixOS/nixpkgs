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

  meta = with lib; {
    description = "Branch of Rake supporting automatic parallelizing of tasks";
    homepage = "http://quix.github.io/rake/";
    maintainers = with maintainers; [
      romildo
      manveru
      nicknovitski
    ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
