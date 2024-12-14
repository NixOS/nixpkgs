{
  stdenv,
  lib,
  fetchFromGitHub,
  bundlerEnv,
}:

let
  rubyEnv = bundlerEnv {
    name = "cewl-ruby-env";
    gemdir = ./.;
  };
in
stdenv.mkDerivation rec {
  pname = "cewl";
  version = "5.5.2";
  src = fetchFromGitHub {
    owner = "digininja";
    repo = "CeWL";
    rev = version;
    sha256 = "sha256-5LTZUr3OMeu1NODhIgBiVqtQnUWYfZTm73q61vT3rXc=";
  };

  buildInputs = [ rubyEnv.wrappedRuby ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.rb $out/bin/
    mv $out/bin/cewl.rb $out/bin/cewl
  '';

  meta = with lib; {
    description = "Custom wordlist generator";
    mainProgram = "cewl";
    homepage = "https://digi.ninja/projects/cewl.php/";
    license = licenses.gpl3Plus;
  };
}
