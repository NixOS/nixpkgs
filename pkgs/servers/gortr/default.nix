{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gortr";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kg42qynqqj05bvfwzd77mpl63y3gnkk15x2a4rspxf4w1ziaxkr";
  };
  modSha256 = "157dpalfz3z1s3mxq63xy6lrkwzyy9xzmvn7wsxkwznjq4djv1a1";

  meta = with lib; {
    description = "The RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
