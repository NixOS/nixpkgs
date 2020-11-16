{ fetchFromGitHub, rustPlatform, stdenv, fetchpatch
, CoreFoundation, libiconv, libresolv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "onefetch";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "o2sh";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l4acikxkxvmdqn10ck4w4f100vz7kfrzghz5h4haj7ycrr35j3l";
  };

  cargoSha256 = "0rmy0jnf5rqd4dqyl6rinxb3n3rzqnixrybs4i27lcas9m753z40";

  buildInputs = with stdenv;
    lib.optionals isDarwin [ CoreFoundation libiconv libresolv Security ];

  meta = with stdenv.lib; {
    description = "Git repository summary on your terminal";
    homepage = "https://github.com/o2sh/onefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 kloenk ];
  };
}
