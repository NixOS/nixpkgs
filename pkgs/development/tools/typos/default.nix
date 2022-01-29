{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bsPwyTucFJdKp+r8uJ2XLOzvbTM4i5EmSY+3VgyAFuE=";
  };

  cargoSha256 = "sha256-2wJXx8xHPrjzKupuen3XfRMSviYEwYK3nbL5/uTDIzE=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
