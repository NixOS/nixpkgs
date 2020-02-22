{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z8x70mwg0mvz6iap92gil37d4kpg5dizlyfx3zk7984ynycgap8";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0nqcp54nwv4ic5jc3cgg15rh8dgkixfgkwb5q47rv8ding4cd0j5";

  meta = with stdenv.lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = https://github.com/euank/pazi;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
