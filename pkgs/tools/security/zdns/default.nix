{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zdns";
  version = "20210327-${lib.strings.substring 0 7 rev}";
  rev = "8c53210f0b9a4fe16c70a5d854e9413c3d0c1ba2";

  src = fetchFromGitHub {
    owner = "zmap";
    repo = pname;
    inherit rev;
    sha256 = "0pdfz1489ynpw72flalnlkwybp683v826icjx7ljys45xvagdvck";
  };

  vendorSha256 = "0b8h5n01xmhar1a09svb35ah48k9zdy1mn5balq0h2l0jxr05z78";

  subPackages = [ "zdns" ];

  meta = with lib; {
    description = "CLI DNS lookup tool";
    homepage = "https://github.com/zmap/zdns";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
