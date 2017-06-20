{ buildRubyGem, fetchFromGitHub, lib, bundler, ruby, nix, nix-prefetch-git }:

buildRubyGem rec {
  inherit ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "manveru";
    repo = "bundix";
    rev = version;
    sha256 = "0lnzkwxprdz73axk54y5p5xkw56n3lra9v2dsvqjfw0ab66ld0iy";
  };

  buildInputs = [bundler];

  postInstall = ''
    substituteInPlace $GEM_HOME/gems/${gemName}-${version}/lib/bundix.rb \
      --replace \
        "'nix-instantiate'" \
        "'${nix.out}/bin/nix-instantiate'" \
      --replace \
        "'nix-hash'" \
        "'${nix.out}/bin/nix-hash'" \
      --replace \
        "'nix-prefetch-url'" \
        "'${nix.out}/bin/nix-prefetch-url'" \
      --replace \
        "'nix-prefetch-git'" \
        "'${nix-prefetch-git}/bin/nix-prefetch-git'"
  '';

  meta = {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru zimbatm ];
    platforms = lib.platforms.all;
  };
}
