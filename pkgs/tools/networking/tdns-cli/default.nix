{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tdns-cli";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "rotty";
    repo = name;
    rev = "v${version}";
    sha256 = "0nn036in5j1h0vxkwif0lf7fn900zy4f4kxlzy6qdx3jakgmxvwh";
  };

  cargoSha256 = "14mmfj5my8gbsdhlhz17w8wjcc085c6dkj78kwr2hhsbcxp1vjgg";

  meta = with lib; {
    description = "DNS tool that aims to replace dig and nsupdate";
    homepage = "https://github.com/rotty/tdns-cli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ astro ];
  };
}
