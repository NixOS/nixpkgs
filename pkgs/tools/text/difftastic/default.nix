{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "difftastic";
  version = "unstable-2021-07-09";

  src = fetchFromGitHub {
    owner = "wilfred";
    repo = pname;
    rev = "1dc6ab3977e4d81e71cff1ac4289987773f64b58";
    sha256 = "zNCY1pZM6IPbalKJZtGvS1RT6osdgTmCerfXYNfuXkA=";
  };

  cargoSha256 = "/lJB5m7Si+w3lhbdRStjX6Txmj9BafsbPwyrRDp3Yv8=";

  meta = with lib; {
    description = "A syntax-aware diff";
    homepage = "https://github.com/Wilfred/difftastic";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
  };
}
