{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, nixosTests
}:

buildGoModule rec {
  pname = "ghostunnel";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    rev = "v${version}";
    sha256 = "sha256-VameENcHZ6AttV0D8ekPGGFoMHTiTXAY2FxK/Nxwjmk=";
  };

  vendorSha256 = null;

  deleteVendor = true;

  # The certstore directory isn't recognized as a subpackage, but is when moved
  # into the vendor directory.
  postUnpack = ''
    mkdir -p $sourceRoot/vendor/ghostunnel
    mv $sourceRoot/certstore $sourceRoot/vendor/ghostunnel/
  '';

  passthru.tests = {
    nixos = nixosTests.ghostunnel;
    podman = nixosTests.podman-tls-ghostunnel;
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A simple TLS proxy with mutual authentication support for securing non-TLS backend applications";
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    license = licenses.asl20;
    maintainers = with maintainers; [ roberth ];
  };
}
