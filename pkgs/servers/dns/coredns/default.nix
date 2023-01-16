{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "coredns";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-Kb4nkxuyZHJT5dqFSkqReFkN8q1uYm7wbhSIiLd8Hck=";
  };

  vendorSha256 = "sha256-nyMeKmGoypDrpZHYHGjhRnjgC3tbOX/dlj96pnXrdLE=";

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace "TestZoneExternalCNAMELookupWithProxy" \
                "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace "TestReadme" "SkipReadme"
  '' + lib.optionalString stdenv.isDarwin ''
    # loopback interface is lo0 on macos
    sed -E -i 's/\blo\b/lo0/' plugin/bind/setup_test.go
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
