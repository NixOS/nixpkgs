{ buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "ulid";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "oklog";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/oQPgcO1xKbHXutxz0WPfIduShPrfH1l+7/mj8jLst8=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorSha256 = "sha256-s1YkEwFxE1zpUUCgwOAl8i6/9HB2rcGG+4kqnixTit0=";

  meta = with lib; {
    description = "A UUID compatible sortable identifier writen in Go";
    license = licenses.asl20;
    homepage = "https://github.com/oklog/ulid";
    maintainers = with maintainers; [ poptart ];
  };
}
