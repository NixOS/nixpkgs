{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "serioussam";

  version = "1.10.6b";

  src = fetchFromGitHub {
    owner = "tx00100xt";
    repo = "SeriousSamClassic";
    rev = version;
    hash = "sha256-GjV42HQuodWIHc5CFMaE6muc6lJm1eetKrUDWVXTK5I=";
  };
}
