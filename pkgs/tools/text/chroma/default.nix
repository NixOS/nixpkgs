{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "chroma";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "19d7yr6q8kwrm91yyglmw9n7wa861sgi6dbwn8sl6dp55czfwvaq";
    # populate values otherwise taken care of by goreleaser,
    # unfortunately these require us to use git. By doing
    # this in postFetch we can delete .git afterwards and
    # maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"

      commit="$(git rev-parse HEAD)"
      date=$(git show -s --format=%aI "$commit")

      substituteInPlace "$out/cmd/chroma/main.go" \
        --replace 'version = "?"' 'version = "${version}"' \
        --replace 'commit  = "?"' "commit = \"$commit\"" \
        --replace 'date    = "?"' "date = \"$date\""

      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorSha256 = "0y8mp08zccn9qxrsj9j7vambz8dwzsxbbgrlppzam53rg8rpxhrg";

  subPackages = [ "cmd/chroma" ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
