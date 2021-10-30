{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "sha256-p3JvaDDebbIgOvTh0e7yYe3qOXvj1pLSG95hpK62M7s=";
  };

  vendorSha256 = "sha256-KJ8haktP9qoG5QsKnTOkvE8L+SQ9Z6hrsjUeS0wrdLs=";

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
