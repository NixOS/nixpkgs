{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "coredns";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "sha256-9+DwOSfhX+sNnvLMgHKUQSozXzT9k8u7Q1p8FvbvsTE=";
  };

  vendorSha256 = "sha256-L4GzOY7oZlC3Et/kEBXrrQGt5/c3jHZimY7NnjXYSro=";

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

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo superherointj ];
  };
}
