{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "chroma";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0vzxd0jvjaakwjvkkkjppakjb00z44k7gb5ng1i4924agh24n5ka";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ git ];

  # populate values otherwise taken care of by goreleaser
  # https://github.com/alecthomas/chroma/issues/435
  postPatch = ''
    commit="$(git rev-parse HEAD)"
    date=$(git show -s --format=%aI "$commit")

    substituteInPlace cmd/chroma/main.go \
      --replace 'version = "?"' 'version = "${version}"' \
      --replace 'commit  = "?"' "commit = \"$commit\"" \
      --replace 'date    = "?"' "date = \"$date\""
  '';

  vendorSha256 = "16cnc4scgkx8jan81ymha2q1kidm6hzsnip5mmgbxpqcc2h7hv9m";

  subPackages = [ "cmd/chroma" ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
