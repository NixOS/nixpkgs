{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zseYcam641qln8ax9JNBoJbn4RIsgpUtTfmU/uqeGRw=";
  };

  cargoSha256 = "sha256-8ZpdSjldRBrriB2yzyxYkJsjJQ1O4EWzGp52k4Prv2c=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
