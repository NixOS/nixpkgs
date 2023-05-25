{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x2lsEYPv6FtARdRd5r+vvV+/S4uZkRXPhsoXmplgIAM=";
  };

  cargoHash = "sha256-toUS1JAbJ8gbOsi87SXiqoaW0X7enAh4Iha3VeCa3WY=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  postInstall = ''
    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
