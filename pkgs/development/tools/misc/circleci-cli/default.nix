{ stdenv, fetchFromGitHub, buildGoPackage }:

let
  owner = "CircleCI-Public";
  pname = "circleci-cli";
  version = "0.1.2307";
in
buildGoPackage rec {
  name = "${pname}-${version}";
  inherit version;

  src =  fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "v${version}";
    sha256 = "0z71jnq42idvhgpgn3mdpbajmgn4b41rpifv5qxn3h1pgi08f75s";
  };

  goPackagePath = "github.com/${owner}/${pname}";

  meta = with stdenv.lib; {
    # Box blurb edited from the AUR package circleci-cli
    description = ''
      Command to enable you to reproduce the CircleCI environment locally and
      run jobs as if they were running on the hosted CirleCI application.
    '';
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://circleci.com/;
  };
}
