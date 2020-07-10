{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "diskonaut";
    rev = version;
    sha256 = "0vnmch2cac0j9b44vlcpqnayqhfdfdwvfa01bn7lwcyrcln5cd0z";
  };

  cargoSha256 = "03hqdg6pnfxnhwk0xwhwmbrk4dicjpjllbbai56a3391xac5wmi6";

  # some tests fail due to non-portable (in terms of filesystems) measurements of block sizes
  # try to re-enable tests once actual-file-size is added
  # see https://github.com/imsnif/diskonaut/issues/50 for more info
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/imsnif/diskonaut";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ evanjs ];
  };
}
