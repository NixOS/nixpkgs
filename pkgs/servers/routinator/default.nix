{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0v0j8lv1l7mxxwv7ycissya0rrvjqidb37dylqqy4zvirmk1b2av";
  };

  cargoSha256 = "19333br2r27s0rsv7imsv2y1j9gmljy4v8bqybvblrw1vc5961kq";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
