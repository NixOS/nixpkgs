{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3ZN/SCTQ5k0X4cqnrpp8Yt1QDnYkT2RbMLKpDfdWaxk=";
  };

  vendorSha256 = "sha256-UhES+jJil6+JmGH27p/LC/b5rZfHC4RIjA9nCFeB7Ao=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
