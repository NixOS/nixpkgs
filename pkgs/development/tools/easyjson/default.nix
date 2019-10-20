{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "easyjson";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mailru";
    repo = "easyjson";
    rev = "v${version}";
    sha256 = "13zv5fvjp3nr65lhqhiw6i6mlmqvyls882rlmcas0ab35alsxni8";
  };

  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  enableParallelBuilding = true;
  # go: directory benchmark is outside main module
  subPackages = [ "easyjson" ];

  meta = with lib; {
    homepage = "https://github.com/mailru/easyjson";
    description = "Fast JSON serializer for golang";
    license = licenses.mit;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
