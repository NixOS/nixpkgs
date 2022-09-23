{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ep+bfmeXbHGD0xEqKQr1dfh7MOPfySdcZcTaEonOSas=";
  };

  cargoSha256 = "sha256-IfIOettKHVay9Ls3cT9BI0zmGHle2Ew227BztbiLxEw=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
