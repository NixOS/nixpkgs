{ stdenv, lib, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A54KTToi69l0/Nrz4K8EqFpCodbomYUI/zTP++Y4FF0=";
  };

  cargoSha256 = "sha256-RbgLZvNZSNjYImVm8Ax5cAL3R0XqlVz5ApPYKj93GEE=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
