{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "sha256-Wm3gfir6blQFLLi+2bT5Y/5tf7qUxEddJQ7tCYfBGgM=";
  };

  vendorSha256 = "0icxy6wbqjqawr6i5skwp1z37fq303p8f95crd8lwn6pjjiqzk4i";

  buildFlagsArray = [ "-ldflags=-s -w -X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ petabyteboy penguwin SuperSandro2000 ];
  };
}
