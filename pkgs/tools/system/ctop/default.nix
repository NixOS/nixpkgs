{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mm6hl5qklfv0yffj6cgypsgcrk4fq6p60djycfgj20yhz9cmf9x";
  };

  patches = [
    # Version 0.7.2 does not build with go 1.13.
    # TODO: Remove once(and if) https://github.com/bcicen/ctop/pull/178 is merged and lands in a release.
    ./go-1.13-deps.patch
  ];

  modSha256 = "0ad1gvamckg94r7f68cnjdbq9nyz6c3hh339hy4hghxd3rd1qskn";

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam ];
  };
}
