{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cariddi";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PXQljC9rwlxXQ96fII3EjD4NXu61EMkYvMWqkcJZ4vU=";
  };

  vendorSha256 = "sha256-zNUdglsfy6lEV54afCAoigxa3rR0qf/e3+B4PvVRIa4=";

  meta = with lib; {
    description = "Crawler for URLs and endpoints";
    homepage = "https://github.com/edoardottt/cariddi";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
