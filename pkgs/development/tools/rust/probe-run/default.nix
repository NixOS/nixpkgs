{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, rustfmt, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "probe-run";
    rev = "v${version}";
    sha256 = "1jgml8jgnv8a2giblx8jxvfh16y296xm9p6m291i0xcg3fccga70";
  };

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ];
  cargoSha256 = "14hrvdmrv9ybz2v5pvz6m3ld074l1aiqb2m9y1pch01i1mg347mw";

  meta = with stdenv.lib; {
    description = "Custom Cargo runner that transparently runs Rust firmware on a remote device";
    homepage = "https://github.com/knurling-rs/probe-run";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.astro ];
  };
}
