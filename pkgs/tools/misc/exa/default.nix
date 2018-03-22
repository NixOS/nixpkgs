{ stdenv, fetchFromGitHub, rustPlatform, cmake, perl, pkgconfig, zlib
, darwin, libiconv
}:

with rustPlatform;

buildRustPackage rec {
  name = "exa-${version}";
  version = "0.8.0";

  cargoSha256 = "08zzn3a32xfjkmpawcjppn1mr26ws3iv40cckiz8ldz4qc8y9gdh";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "v${version}";
    sha256 = "0jy11a3xfnfnmyw1kjmv4ffavhijs8c940kw24vafklnacx5n88m";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ zlib ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security ]
  ;

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = https://the.exa.website;
    license = licenses.mit;
    maintainers = [ maintainers.ehegnes ];
  };
}
