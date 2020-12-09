{ stdenv, lib, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "tagref";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3R6vhevSld9IjJMsGl5Rwv0ADMjm94NeZxvl8eYHR2Y=";
  };

  cargoSha256 = "sha256-pLugAT8QlgxawkR2y+LIacRh4nB59qpKLJjxc81CNDY=";

  meta = with lib; {
    description = "Tagref helps you refer to other locations in your codebase.";
    homepage = "https://github.com/stepchowfun/tagref";
    license = licenses.mit;
    maintainers = [ maintainers.yusdacra ];
    platforms = platforms.unix;
  };
}
