{ lib
, fetchurl
, rustPlatform
}:

with rustPlatform; 

buildRustPackage rec {
  version = "0.19.1";
  name = "geckodriver-${version}";

  src = fetchurl {
    url = "https://github.com/mozilla/geckodriver/archive/v${version}.tar.gz";
    sha256 = "04zpv4aiwbig466yj24hhazl5hrapkyvwlhvg0za5599ykzdv47m";
  };

  cargoSha256 = "1cny8caqcd9p98hra1k7y4d3lb8sxsyaplr0svbwam0d2qc1c257";

  meta = with lib; {
    description = "Proxy for using W3C WebDriver-compatible clients to interact with Gecko-based browsers";
    homepage = https://github.com/mozilla/geckodriver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
