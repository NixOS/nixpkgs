{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "git-fire";
  version = "unstable-2017-08-27";

  src = fetchFromGitHub {
    owner = "qw3rtman";
    repo = "git-fire";
    rev = "d72b68ed356f726c77c60294f9220275f16c9931";
    sha256 = "1hdwkhyjjx31y0lpjkhbb4f5y9f7g70fnd4c2246cmk2rbsvj5b2";
  };

  installPhase = ''
    install -D -m755 $src/git-fire $out/bin/git-fire
  '';

  meta = with lib; {
    description = ''
      Push ALL changes in a git repository
    '';
    longDescription = ''
      In the event of an emergency (fire, etc.), automatically commit all changes/files in a repository, pushing to all known remotes all commits and stashes.
    '';
    homepage = "https://github.com/qw3rtman/git-fire";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ swflint ];
    mainProgram = "git-fire";
  };
}
