{ stdenv, fetchFromGitHub, rustPlatform, openssl, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "exa-${version}";
  version = "2016-04-20";

  depsSha256 = "0qsqkgc1wxigvskhaamgfp5pyc2kprsikhcfccysgs07w44nxkd0";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "110a1c716bfc4a7f74f74b3c4f0a881c773fcd06";
    sha256 = "136yxi85m50vwmqinr1wnd0h29n5yjykqqqk9ibbcmmhx8sqhjzf";
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
