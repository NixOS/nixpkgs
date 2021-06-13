{ lib, bundlerApp, bundlerUpdateScript, ruby }:

bundlerApp {
  inherit ruby;
  pname = "htmlbeautifier";
  gemdir = ./.;
  exes = [ "htmlbeautifier" ];

  passthru.updateScript = bundlerUpdateScript "htmlbeautifier";

  meta = with lib; {
    description = "A normaliser/beautifier for HTML that also understands embedded Ruby, ideal for tidying up Rails templates";
    homepage = "https://github.com/threedaymonk/htmlbeautifier";
    license = licenses.mit;
    platforms = ruby.meta.platforms;
    maintainers =  with maintainers; [ mveytsman ];
  };
}
