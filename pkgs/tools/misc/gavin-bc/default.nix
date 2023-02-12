{ lib
, stdenv
, fetchFromGitea
}:

stdenv.mkDerivation (self: {
  pname = "gavin-bc";
  version = "6.2.4";

  src = fetchFromGitea {
    domain = "git.gavinhoward.com";
    owner = "gavin";
    repo = "bc";
    rev = self.version;
    hash = "sha256-KQheSyBbxh2ROOvwt/gqhJM+qWc+gDS/x4fD6QIYUWw=";
  };

  meta = {
    homepage = "https://git.gavinhoward.com/gavin/bc";
    description = "Gavin Howard's BC calculator implementation";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
