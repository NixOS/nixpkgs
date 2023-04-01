{ buildRubyGem
, fetchFromGitHub
, fetchpatch
, makeWrapper
, lib
, bundler
, nix
, nix-prefetch-git
}:

buildRubyGem rec {
  inherit (bundler) ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "bundix";
    rev = version;
    sha256 = "sha256-iMp6Yj7TSWDqge3Lw855/igOWdTIuFH1LGeIN/cpq7U=";
  };

  patches = [
    # https://github.com/nix-community/bundix/pull/80
    (fetchpatch {
      url = "https://github.com/nix-community/bundix/commit/3d7820efdd77281234182a9b813c2895ef49ae1f.patch";
      hash = "sha256-ShluCWfRQxR+vkXqa7Fh7+WHKf6vAsa9/DVeXjpAXLk=";
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
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with lib.maintainers; [ manveru marsam zimbatm ];
    platforms = lib.platforms.all;
  };
}
