{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-omQTyJ7XKRBjX8jyWLONajAYnwr93nElrwDLdvs2MxM=";
  };

  cargoHash = "sha256-57KcqALWbiGtp6HWSN42gZ0St38oHu3inZ0TT77j7go=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
