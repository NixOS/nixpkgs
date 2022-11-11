{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wprecon";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "blackbinn";
    repo = pname;
    rev = version;
    hash = "sha256-23zJD3Nnkeko+J2FjPq5RA5dIjORMXvwt3wtAYiVlQs=";
  };

  vendorSha256 = "sha256-FYdsLcW6FYxSgixZ5US9cBPABOAVwidC3ejUNbs1lbA=";

  postFixup = ''
    # Rename binary
    mv $out/bin/cli $out/bin/${pname}
  '';

  meta = with lib; {
    description = "WordPress vulnerability recognition tool";
    homepage = "https://github.com/blackbinn/wprecon";
    # License Zero Noncommercial Public License 2.0.1
    # https://github.com/blackbinn/wprecon/blob/master/LICENSE
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ fab ];
  };
}
