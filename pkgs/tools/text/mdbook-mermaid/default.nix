{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zXgXgcMF7MOa9Vx3rhv9aavqRCfMcyRLtaWEvYlyaTs=";
  };

  cargoPatches = [
    # https://github.com/badboy/mdbook-mermaid/pull/23
    (fetchpatch {
      name = "update-mdbook-for-rust-1.64.patch";
      url = "https://github.com/badboy/mdbook-mermaid/commit/5a3432d1b28ef9a065dd37aa77b82a3593358793.patch";
      hash = "sha256-NkCxGmRdwJ+jdkgxp5gWfGpgpLpEpKUd44LyPx0kyEE=";
    })
  ];

  cargoHash = "sha256-IkMBnBuobrJzR6+030/Wfbu2ZCjvFnjBV+6sSWdiNUw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add mermaid.js support";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
