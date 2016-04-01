{ stdenv, fetchFromGitHub, rustPlatform, openssl, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "exa-${version}";
  version = "2016-03-22";

  depsSha256 = "18anwh235kzziq6z7md8f3rl2xl4l9d4ivsqw9grkb7yivd5j0jk";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "8805ce9e3bcd4b56f8811a686dd56c47202cdbab";
    sha256 = "0dkvk0rsf068as6zcd01p7959rdjzm26mlkpid6z0j168gp4kh4q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl zlib ];

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
    homepage = http://bsago.me/exa;
    license = licenses.mit;
    maintainer = [ maintainers.ehegnes ];
  };
}
