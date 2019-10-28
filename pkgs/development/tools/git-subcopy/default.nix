{ callPackage, lib, fetchFromGitLab }:

let
  pname = "git-subcopy";
  version = "0.1.0";

  package = (callPackage ./Cargo.nix {}).rootCrate.build;
in package.overrideAttrs (attrs: {
  name = "${pname}-${version}";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = pname;
    rev = version;

    sha256 = "1347b1grckrqlmb9h6p5xfcwlry9j1x3az8zbhrl7gf61x5qas94";
  };

  postInstall = ''
    # Remove pointless file which can cause collisions
    rm $out/lib/link
  '';

  meta = with lib; {
    description = "Link files across git repositories";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
})
