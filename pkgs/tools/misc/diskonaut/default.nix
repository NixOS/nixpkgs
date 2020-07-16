{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diskonaut";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "diskonaut";
    rev = version;
    sha256 = "125ba9qwh7j8bz74w2zbw729s1wfnjg6dg8yicqrp6559x9k7gq5";
  };

  cargoSha256 = "0vvbrlmviyn9w8i416767vhvd1gqm3qjvia730m0rs0w5h8khiqf";

  meta = with stdenv.lib; {
    description = "Terminal disk space navigator";
    homepage = "https://github.com/imsnif/diskonaut";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ evanjs ];
  };
}
