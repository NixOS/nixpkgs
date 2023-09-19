{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fx";
  version = "30.0.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = pname;
    rev = version;
    hash = "sha256-MRWDitL9nATi6+oaOJ/A+iaNLztWBZ+Mrs7Hkt0lhL8=";
  };

  vendorHash = "sha256-cIyh/FC1lcUgPeUZKrh+kCZmSKGE7Bo411eI0dZeMx4=";

  meta = with lib; {
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    changelog = "https://github.com/antonmedv/fx/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
