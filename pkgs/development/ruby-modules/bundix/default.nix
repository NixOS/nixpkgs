{ buildRubyGem, fetchFromGitHub, makeWrapper, lib, bundler, nix,
  nix-prefetch-git, fetchpatch }:

buildRubyGem rec {
  inherit (bundler) ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "bundix";
    rev = version;
    sha256 = "05y8sy6v9km1dwvpjzkjxpfzv95g6yzac1b5blac2f1r2kw167p8";
  };

  patches = [
    # write trailing newline to gemset.nix
    # https://github.com/nix-community/bundix/pull/78
    (fetchpatch {
      url = "https://github.com/nix-community/bundix/commit/02ca7a6c656a1e5e5465ad78b31040d82ae1a7e6.patch";
      sha256 = "18r30icv7r79dlmxz1d1qlk5b6c7r257x23sqav55yhfail9hqrb";
    })
  ];

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
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru qyliss zimbatm ];
    platforms = lib.platforms.all;
  };
}
