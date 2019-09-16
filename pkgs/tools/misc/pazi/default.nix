{ stdenv, fetchFromGitHub, rustPlatform, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gnh6047hacavcb9bhps9d1zjns66rdbd158fw20kjp1lln5srrn";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoSha256 = "15s03vwgl6562n5h9r4d5kp2r168jakn5nwnyibmrs8r5q0idmjs";

  cargoPatches = [ ./cargo-lock.patch ];

  meta = with stdenv.lib; {
    description = "An autojump \"zap to directory\" helper";
    homepage = https://github.com/euank/pazi;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bbigras ];
  };
}
