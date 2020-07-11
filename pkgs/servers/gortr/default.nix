{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gortr";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "08nbvw5pqd8wdd8vrsr4d50zfqwg175brh7m0pvv4165gnv8k5bf";
  };
  vendorSha256 = "1nwrzbpqycr4ixk8a90pgaxcwakv5nlfnql6hmcc518qrva198wp";

  meta = with lib; {
    description = "The RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}