{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KdPr/6wGyoHhEwfPektL+B1khyoRfxDHI4aFcKNU0TM=";
  };

  cargoSha256 = "sha256-MLlGz7Sid0G52//XekqkZgzLqFL7xoUwT6OvpaF4jm0=";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 kloenk ];
  };
}
