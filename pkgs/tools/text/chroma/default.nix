{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "chroma";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "14jp6f83ca2srcylf9w6v7cvznrm1sbpcs6lk7pimgr3jhy5j339";
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

  vendorSha256 = "1l5ryhwifhff41r4z1d2lifpvjcc4yi1vzrzlvkx3iy9dmxqcssl";

  modRoot = "./cmd/chroma";


  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
