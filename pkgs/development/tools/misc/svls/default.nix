{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.28";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "0k3njqdhcbgj6l1rwyk6crylpwzgg70fsh5yfgp4p2zvynw4hrx2";
  };

  cargoSha256 = "0aj5d0ca70ggiarjkrj4z34zbdpwlhbsssqf3l9ypblqhfvq2wvl";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
