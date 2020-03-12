{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "0p4ibvv0qrflqdc2bi9rjn7yhn01ncxrpqpxmh8cbq67rbvm7jnx";
  };

  cargoSha256 = "1wvqln3xr192ml9gfzfv6qdv59g654xyaw15d790sysm82gd0inz";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
