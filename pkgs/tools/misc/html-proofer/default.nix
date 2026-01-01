{
  bundlerEnv,
  ruby,
  lib,
  bundlerUpdateScript,
}:

bundlerEnv rec {
<<<<<<< HEAD
=======
  name = "${pname}-${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "html-proofer";
  version = (import ./gemset.nix).html-proofer.version;

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript pname;

<<<<<<< HEAD
  meta = {
    description = "Tool to validate HTML files";
    homepage = "https://github.com/gjtorikian/html-proofer";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool to validate HTML files";
    homepage = "https://github.com/gjtorikian/html-proofer";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "htmlproofer";
  };
}
