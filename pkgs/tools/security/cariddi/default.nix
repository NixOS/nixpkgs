{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5FXHJvHrfmttesgI6IE3+AedLXf1skWV12+WjbR4Xy8=";
  };

  vendorSha256 = "sha256-ZIlOPOrAWdwHwgUR/9eBEXaIcNfWh7yEQ/c9iE8sLiY=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
