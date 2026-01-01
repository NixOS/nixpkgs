{
  lib,
  stdenv,
  bundlerEnv,
  ruby,
  bundlerUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "watson-ruby";
  version = (import ./gemset.nix).watson-ruby.version;

  dontUnpack = true;

  installPhase =
    let
      env = bundlerEnv {
        name = "watson-ruby-gems-${version}";
        inherit ruby;
        # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
        gemdir = ./.;
      };
    in
    ''
      mkdir -p $out/bin
      ln -s ${env}/bin/watson $out/bin/watson
    '';

  passthru.updateScript = bundlerUpdateScript "watson-ruby";

<<<<<<< HEAD
  meta = {
    description = "Inline issue manager";
    homepage = "https://goosecode.com/watson/";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Inline issue manager";
    homepage = "https://goosecode.com/watson/";
    license = with licenses; mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      robertodr
      nicknovitski
    ];
    mainProgram = "watson";
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
