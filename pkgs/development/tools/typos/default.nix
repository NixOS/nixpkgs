{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.13.12";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SP2Di3kAcrAriZ4E7aPSBAZm46REIW82LrbWSmKhA5k=";
  };

  cargoHash = "sha256-3ExXZ7lUnT/54TUembKk47OUVpAzHrWPAro2CcXiYmU=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
