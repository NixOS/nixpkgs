{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "impl-unstable";
  version = "2019-11-19";
  rev = "6b9658ad00c7fbd61a7b50c195754413f6c4142c";

  goPackagePath = "github.com/josharian/impl";

  src = fetchFromGitHub {
    inherit rev;
    owner = "josharian";
    repo = "impl";
    sha256 = "1d4fvj7fgiykznx1z4fmcc06x5hsqp9wn62m5qm1ds8m0rjqaxwi";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "impl generates method stubs for implementing an interface.";
    homepage = "https://github.com/josharian/impl";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
