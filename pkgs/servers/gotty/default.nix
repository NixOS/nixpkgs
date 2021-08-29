{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gotty";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sorenisanerd";
    repo = "gotty";
    rev = "v${version}";
    sha256 = "06ngxnblwkmiln9bxikg9q2wdlh45481pnz87bpsw2r7hc69bv9n";
  };

  vendorSha256 = "0mzf5209r3fzqf9q98j3b2cdzvfa3kg62xn0spx5zr6nabmhaa79";

  # upstream did not update the tests, so they are broken now
  # https://github.com/sorenisanerd/gotty/issues/13
  doCheck = false;

  meta = with lib; {
    description = "Share your terminal as a web application";
    homepage = "https://github.com/sorenisanerd/gotty";
    maintainers = with maintainers; [ prusnak ];
    license = licenses.mit;
  };
}
