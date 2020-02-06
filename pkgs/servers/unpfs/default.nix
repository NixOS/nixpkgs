{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "unpfs";
  version = "0.0.2019-05-17";

  src = fetchFromGitHub {
    owner = "pfpacket";
    repo = "rust-9p";
    rev = "01cf9c60bff0f35567d876db7be7fb86032b44eb";
    sha256 = "0mhmr1912z5nyfpcvhnlgb3v67a5n7i2n9l5abi05sfqffqssi79";
  };

  sourceRoot = "source/example/unpfs";

  cargoSha256 = "1d33nwj3i333a6ji3r3037mgg553lc3wsawm0pz13kbvhjf336i8";

  RUSTC_BOOTSTRAP = 1;

  postInstall = ''
    install -D -m 0444 ../../README* -t "$out/share/doc/${pname}"
    install -D -m 0444 ../../LICEN* -t "$out/share/doc/${pname}"
  '';

  meta = with stdenv.lib; {
    description = "9P2000.L server implementation in Rust";
    homepage = "https://github.com/pfpacket/rust-9p";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raskin ];

    # macOS build fails: https://github.com/pfpacket/rust-9p/issues/7
    platforms = with platforms; linux;
  };
}
