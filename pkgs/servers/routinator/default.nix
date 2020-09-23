{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lldrb469vc7l6bkwgxz38n7lyxh74cb88xak5r0sjm1ip5q0glp";
  };

  cargoSha256 = "sha256:19yzx9h02cx5dldliaq814n84f8w0s3nbyjk3pgia2siim5mdv94";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
