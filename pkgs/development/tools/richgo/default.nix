{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "richgo";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${version}";
    sha256 = "07ipa54c4mzm6yizgvkm6x5yim1xgv3f0xdxg35qziacdfcwd6m4";
  };

  vendorSha256 = "1nvk3akjwfcbvif1w4cglsqplcajlwq3mnvk9b75nmn9qaqfbfjf";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Enrich `go test` outputs with text decorations.";
    homepage = "https://github.com/kyoh86/richgo";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
