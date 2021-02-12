{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fastmod";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nrh6h5imbpl7i0sqqm16x9ggazww5739vng1ay1v6sgbbs0a095";
  };

  cargoSha256 = "0sycwdpgngp9fi0fj81yj3h1avn8d5qrc41bw1r54n2822xn8399";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A utility that makes sweeping changes to large, shared code bases";
    homepage = "https://github.com/facebookincubator/fastmod";
    license = licenses.asl20;
    maintainers = with maintainers; [ jduan ];
  };
}
