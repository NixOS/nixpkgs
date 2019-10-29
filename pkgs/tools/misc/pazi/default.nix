{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bbci7bvrwl7lsslf302jham1pcw32fi7nwgqyjpfjyzvnpfgndz";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "0nqcp54nwv4ic5jc3cgg15rh8dgkixfgkwb5q47rv8ding4cd0j5";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = with stdenv.lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = https://github.com/euank/pazi;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
