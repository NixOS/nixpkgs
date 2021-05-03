{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "chroma";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0zzk4wcjgxa9lsx8kwpmxvcw67f2fr7ai37jxmdahnws0ai2c2f7";
    leaveDotGit = true;
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

  vendorSha256 = "0y8mp08zccn9qxrsj9j7vambz8dwzsxbbgrlppzam53rg8rpxhrg";

  subPackages = [ "cmd/chroma" ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
