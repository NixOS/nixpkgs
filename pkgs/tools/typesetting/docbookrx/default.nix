{ lib
, fetchFromGitHub
, stdenv
, ruby
, bundlerEnv
# , libxml2
}:

let
  env = bundlerEnv {
    name = "docbookrx-env";
    gemdir = ./.;

    inherit ruby;

    # buildInputs = [
    #   libxml2
    # ];

    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

in stdenv.mkDerivation {

  pname = "docbookrx";
  version = "unstable-2018-05-02";

  buildInputs = [ env.wrappedRuby ];

  src = fetchFromGitHub {
    owner = "asciidoctor";
    repo = "docbookrx";
    rev = "682d8c2f7a9e1e6f546c5f7d0067353621c68a7a";
    sha256 = "07jilh17gj8xx4ps4ln787izmhv8xwwwv6fkqqg3pwjni5qikx7w";
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
    description = "(An early version of) a DocBook to AsciiDoc converter written in Ruby.";
    homepage = https://asciidoctor.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

}
