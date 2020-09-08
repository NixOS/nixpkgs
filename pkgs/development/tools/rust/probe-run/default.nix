{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, rustfmt, libusb1 }:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "probe-run";
    rev = "v${version}";
    sha256 = "0r1asnsslzq0mxhnbwzc3fg6j1i1621p11923yp649lqmz598mcx";
  };

  nativeBuildInputs = [ pkg-config rustfmt ];
  buildInputs = [ libusb1 ];
  cargoSha256 = "14rw1q329r9xs28qyy5qhjmw9v8bjab74gdzslky1di6ynkwizd5";

  meta = with stdenv.lib; {
    description = "Custom Cargo runner that transparently runs Rust firmware on a remote device";
    homepage = "https://github.com/knurling-rs/probe-run";
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.astro ];
  };
}
