{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "routedns";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "routedns";
    # https://github.com/folbricht/routedns/issues/237
    rev = "02f14a567fee2a289810979446f5260b8a31bf73";
    sha256 = "sha256-oImimNBz1qizUPD6qHi73fGKNCu5cii99GIUo21e+bs=";
  };

  vendorSha256 = "sha256-T6adpxJgOPGy+UOOlGAAf1gjk1wJxwOc9enfv9X3LBE=";

  subPackages = [ "./cmd/routedns" ];

  meta = with lib; {
    homepage = "https://github.com/folbricht/routedns";
    description = "DNS stub resolver, proxy and router";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jsimonetti ];
    platforms = platforms.linux;
  };
}
