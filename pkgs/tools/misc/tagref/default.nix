{ stdenv, lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y1c0v2zjpav1n72pgf3kpqdz6ixp2mjhcvvza4gzfp865c236nc";
  };

  cargoSha256 = "06ljy213x9lhvqjysz9cjhrrg0ns07qkz27pxd8rih0mk6cck45g";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
