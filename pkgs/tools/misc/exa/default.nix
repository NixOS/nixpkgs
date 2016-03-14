{ stdenv, fetchFromGitHub, rustPlatform, openssl, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "exa-${version}";
  version = "2016-02-15";

  depsSha256 = "1925nhpfph82wn755zf2nmad24f1hzbxq60gpva9sic6rnap4c1x";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "252eba484476369bb966fb1af7f739732b968fc0";
    sha256 = "1smyy32z44zgmhyhlbjaxcgfnlbcwz7am9225yppqfdsiqqgdybf";
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
