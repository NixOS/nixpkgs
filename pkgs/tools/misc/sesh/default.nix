{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sesh";
  version = "be2badd29206f66803b76b62b23f6f5e05befe08";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "be2badd29206f66803b76b62b23f6f5e05befe08";
    sha256 = "sha256-8gn4YdKHurPbPuJ+AeCB7x9IDxTtHGpYUZCKlSdujcs=";
  };

  vendorSha256 = "sha256-zt1/gE4bVj+3yr9n0kT2FMYMEmiooy3k1lQ77rN6sTk=";

}
