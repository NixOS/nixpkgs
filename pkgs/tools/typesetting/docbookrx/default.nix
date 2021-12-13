{ lib
, fetchFromGitHub
, stdenv
, ruby
, bundlerEnv
}:

let
  env = bundlerEnv {
    name = "docbookrx-env";
    gemdir = ./.;

    inherit ruby;

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in stdenv.mkDerivation {

  pname = "docbookrx";
  version = "unstable-2018-05-18";

  buildInputs = [ env.wrappedRuby ];

  src = fetchFromGitHub {
    owner = "asciidoctor";
    repo = "docbookrx";
    rev = "83d1d1235e3bb44506123eda337780a912581cd0";
    sha256 = "sha256-OdPRh7ZIhgM7hs5qPiuxLEUuMEtaXcgZ83M6i6CV6AY=";
  };

  # TODO: I don't know ruby packaging but this does the trick for now
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -a bin/docbookrx $out/bin
    cp -a lib $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "(An early version of) a DocBook to AsciiDoc converter written in Ruby";
    homepage = "https://asciidoctor.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

}
