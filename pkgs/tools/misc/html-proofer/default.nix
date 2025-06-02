{
  bundlerEnv,
  ruby,
  lib,
  bundlerUpdateScript,
}:

bundlerEnv {
  pname = "html-proofer";
  version = "5.0.1.0";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "html-proofer";

  meta = with lib; {
    description = "Tool to validate HTML files";
    homepage = "https://github.com/gjtorikian/html-proofer";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "htmlproofer";
  };
}
