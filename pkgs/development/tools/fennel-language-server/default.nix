{lib
,rustPlatform
,fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "fennel-language-server";
  version = "2022-10-26";

  src = fetchFromGitHub {
    owner = "rydesun";
    repo = pname;
    rev = "e97098400910263cccc7aa826651e1b6745492ee";
    sha256 = "sha256-AwNJsTwiFjQx24iJgwtVffpi+VmfudxvhSSykE0rYYM=";
  };
  cargoSha256 = "sha256-6sA2iI6ANrYo63OH9UhunUZRC1/262h4EbGvDDkgKiQ=";

  meta = with lib; {
    description = "Fennel language server protocol (LSP) support";
    homepage = "https://github.com/rydesun/fennel-language-server";
    platforms = rustPlatform.rust.rustc.meta.platforms;
    license = with licenses; [mit];
    maintainers = with maintainers; [ perigord ];
  };
}
