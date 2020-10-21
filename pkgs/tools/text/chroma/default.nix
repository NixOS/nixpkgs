{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "chroma";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner  = "alecthomas";
    repo   = "chroma";
    rev    = "v${version}";
    sha256 = "1gwwfn26aipzzvyy466gi6r54ypfy3ylnbi8c4xwch9pkgw16w98";
  };

  vendorSha256 = "16cnc4scgkx8jan81ymha2q1kidm6hzsnip5mmgbxpqcc2h7hv9m";

  subPackages = [ "cmd/chroma" ];

  meta = with lib; {
    homepage = "https://github.com/alecthomas/chroma";
    description = "A general purpose syntax highlighter in pure Go";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
