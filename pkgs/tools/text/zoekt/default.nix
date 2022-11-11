{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, git
}:
buildGoModule {
  pname = "zoekt";
  version = "unstable-2021-03-17";

  src = fetchFromGitHub {
    owner = "google";
    repo = "zoekt";
    rev = "d92b3b80e582e735b2459413ee7d9dbbf294d629";
    sha256 = "JdORh6bRdHsAYwsmdKY0OUavXfu3HsPQFkQjRBkcMBo=";
  };

  vendorSha256 = "d+Xvl6fleMO0frP9qr5tZgkzsnH5lPELwmEQEspD22M=";

  checkInputs = [
    git
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast trigram based code search";
    homepage = "https://github.com/google/zoekt";
    license = licenses.asl20;
    maintainers = teams.determinatesystems.members;
  };
}
