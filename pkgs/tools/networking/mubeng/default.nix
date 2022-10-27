{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BY3X9N7XnBZ6mVX/o+EXruJmi3HYWMeY9enSuJY4jWI=";
  };

  vendorSha256 = "sha256-1JxyP6CrJ4/g7o3eGeN1kRXJU/jNLEB8fW1bjJytQqQ=";

  ldflags = [ "-s" "-w" "-X ktbs.dev/mubeng/common.Version=${version}" ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
