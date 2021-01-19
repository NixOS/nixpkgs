{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-44xGZto61a6IYUIe8Xuev0RE2tOECcHXy5k94/bujU0=";
  };

  cargoSha256 = "sha256-qdKZdxPN2VBsiRsiqiwqsrJ+5LtpRnLIyXD4x2Jtls8=";

  meta = with stdenv.lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
