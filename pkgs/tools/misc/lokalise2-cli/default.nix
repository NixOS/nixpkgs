{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lokalise2-cli";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "lokalise";
    repo = "lokalise-cli-2-go";
    rev = "v${version}";
    sha256 = "1iizyr6bv17dpv05whcx34498wbrs0q3gn8s50srvdqrdk9hs4gj";
  };

  vendorSha256 = "17nykcx47h1q55msh43mmf092y5cigarz5486yp6sqp79p6lbjk3";

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
