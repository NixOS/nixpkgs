{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "smimesign";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "smimesign";
    rev = "v${version}";
    sha256 = "12f8vprp4v78l9ifrlql0mvpyw5qa8nlrh5ajq5js8wljzpx7wsv";
  };

  vendorSha256 = "1cldxykm9qj5rvyfafam45y5xj4f19700s2f9w7ndhxgfp9vahvz";

  ldflags = [ "-X main.versionString=v${version}" ];

  meta = with lib; {
    description = "An S/MIME signing utility for macOS and Windows that is compatible with Git";
    homepage = "https://github.com/github/smimesign";
    license = licenses.mit;
    platforms = platforms.darwin ++ platforms.windows;
    maintainers = [ maintainers.enorris ];
  };
}
