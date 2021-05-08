{ lib, buildGoModule, fetchFromGitHub}:

buildGoModule rec {
  pname = "matrix-dendrite";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "dendrite";
    rev = "v${version}";
    sha256 = "15xqd4yhsnnpz5n90fbny9i8lp7ki2z3fbpbd8cvsp49347rm483";
  };

  vendorSha256 = "1l1wydvi0yalas79cvhrqg563cvs57hg9rv6qnkw879r6smb2x1n";

  meta = with lib; {
    homepage = "https://matrix.org";
    description = "Dendrite is a second-generation Matrix homeserver written in Go!";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
    platforms = platforms.unix;
  };
}
