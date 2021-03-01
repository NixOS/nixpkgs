{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-3kDaaPDRbhJyp/CblTKhB0dUeOjroCs3WkjEXL87Od4=";
  };

  vendorSha256 = "sha256-iWYlbGeLp/SiF8/OyWGIHJQB1RJjma9/EDc3zOsjNG8=";

  doCheck = false;

  postInstall = ''
    mv $out/bin/lokalise-cli-2-go $out/bin/lokalise2
  '';

  meta = with lib; {
    description = "Translation platform for developers. Upload language files, translate, integrate via API";
    homepage = "https://lokalise.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ timstott ];
    platforms = platforms.unix;
  };
}
