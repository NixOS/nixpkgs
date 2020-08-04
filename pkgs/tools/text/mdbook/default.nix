{ stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "0rfcvcz3cawyzhdxqyasd9dwrb8c2j6annpl9jx2n6y3ysl345ry";
  };

  cargoSha256 = "02vfdr1zlagjya5i9wf6ag9k01cf20jlm4yqvgrpjg9zrwv4xr4s";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with stdenv.lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
    platforms = platforms.all;
  };
}
