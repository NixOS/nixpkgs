{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "scss_lint";
  gemdir = ./.;
  exes = [ "scss-lint" ];

  passthru.updateScript = bundlerUpdateScript "scss-lint";

  meta = with lib; {
    description = "Tool to help keep your SCSS files clean and readable";
    homepage = "https://github.com/brigade/scss-lint";
    license = licenses.mit;
    maintainers = with maintainers; [
      lovek323
      nicknovitski
    ];
    platforms = platforms.unix;
  };
}
