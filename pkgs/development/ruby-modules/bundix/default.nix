{ buildRubyGem, fetchFromGitHub, makeWrapper, lib, bundler, nix,
  nix-prefetch-git }:

buildRubyGem rec {
  inherit (bundler) ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "manveru";
    repo = "bundix";
    rev = version;
    sha256 = "03jhj1dy0ljrymjnpi6mcxn36a29qxr835l1lc11879jjzvnr2ax";
  };

  buildInputs = [ ruby bundler ];
  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/bundix \
                --prefix PATH : "${nix.out}/bin" \
                --prefix PATH : "${nix-prefetch-git.out}/bin" \
                --prefix PATH : "${bundler.out}/bin" \
                --set GEM_HOME "${bundler}/${bundler.ruby.gemPath}" \
                --set GEM_PATH "${bundler}/${bundler.ruby.gemPath}"
  '';

  meta = {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = https://github.com/manveru/bundix;
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru qyliss zimbatm ];
    platforms = lib.platforms.all;
  };
}
