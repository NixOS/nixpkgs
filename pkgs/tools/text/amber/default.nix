{ lib, stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mmgJCD7kJjvpxyagsoe5CSzqIEZcIiYMAMP3axRphv4=";
  };

  cargoSha256 = "sha256-opRinhTmhZxpAwHNiVOLXL8boQf09Y1NXrWQ6HWQYQ0=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
