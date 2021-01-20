{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g9zr2afi103cwv6ikpmmyh5v055dh47l3wj9a1kbxgms0953iwh";
  };

  cargoSha256 = "0hydlaibanw2vjyxymfbzgwwk2qjv7jsz15gn66ga5vknsqihcrx";

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
