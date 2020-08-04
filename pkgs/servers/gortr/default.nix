{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gortr";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z1z4xl39qmd7df1zb2wsd2ycxr4aa9g23sfgp3ws4lhy5d6hyxw";
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
