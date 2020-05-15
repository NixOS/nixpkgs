{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "corerad";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "corerad";
    rev = "v${version}";
    sha256 = "1r9kvz1ylrnfc7y5c4knqhx6xngh1p8j1axb8bd7h7p51c4i7jz2";
  };

  vendorSha256 = "0ncwf197dx6mqzg69mnyp0iyad585izmydm0yj8ikd0y8ngpx7a3";

  buildFlagsArray = ''
    -ldflags=
    -X github.com/mdlayher/corerad/internal/build.linkTimestamp=1589133047
    -X github.com/mdlayher/corerad/internal/build.linkVersion=v${version}
  '';

  deleteVendor = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/corerad";
    description = "CoreRAD extensible and observable IPv6 NDP RA daemon";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
