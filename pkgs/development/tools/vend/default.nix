{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "vend";
  version = "unstable-2020-08-02";

  # A permanent fork from master is maintained to avoid non deterministic go tidy
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "govendor";
    rev = "f01e881a2959c32f9ac3217c32518a856aaea92e";
    sha256 = "1qwi8wjryv93lmcis5vv5bikghj8qs5j46jh9fkv4fxazv0lxrb0";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage = "https://github.com/nix-community/govendor";
    description = "A utility which vendors go code including c dependencies";
    maintainers = with maintainers; [ c00w ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
