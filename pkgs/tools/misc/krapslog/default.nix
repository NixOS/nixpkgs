{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-MzO6fcBlrGeZoflyFXPVIdQ+y/GkQz3yEeEbXLoDZQY=";
  };

  cargoSha256 = "sha256-r5UGCEMAEVIdVeBPsgBf/CMYtBPS03Joje4sNQ8XfFA=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
