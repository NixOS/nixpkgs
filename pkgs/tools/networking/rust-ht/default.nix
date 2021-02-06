{ lib
, nixosTests
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ht";
  version = "v0.4.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = pname;
    rev = version;
    sha256 = "0w5wqxrjdl3c3gmf3gzwsglsbg11vla3g3rl7jccs2ppiblihgld";
  };

  cargoSha256 = "1zd2vpbh9sivb34pp8zyj4533zh42ra5k0jw9cjz749k7119ny12";

  passthru.tests = { inherit (nixosTests) ht; };

  meta = with lib; {
    description = "Yet another HTTPie clone in Rust";
    homepage = "https://github.com/ducaale/ht";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lcycon ];
  };
}
