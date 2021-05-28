{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m928hy2q8byfpm55nziiz86gcnhdnw3zpj78d8wx0pp318zjbla";
  };

  cargoSha256 = "10xddr5cccc5cmhn4kwi27h3krmgapd7bqcp4rhjlbhdhsw7qxkx";

  # Remove after https://github.com/NixOS/nixpkgs/pull/97000 lands into master
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    unset SDKROOT
  '';

  meta = with stdenv.lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
