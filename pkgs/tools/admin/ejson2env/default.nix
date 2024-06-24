{ lib, buildGoModule, fetchFromGitHub, nix-update-script, testers, callPackage, ejson2env }:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VXkWmmX+4D+j9ODSEeJJbIx+Bfni9d2X22BFQIe4kwk=";
  };

  vendorHash = "sha256-7oy8bCegsvv35zyo2aTFMSGZMFkArmxy0rOpK6WlubI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion { package = ejson2env; };
      decryption = callPackage ./test-decryption.nix {};
    };
  };

  meta = with lib; {
    description = "Decrypt EJSON secrets and export them as environment variables";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.mit;
    mainProgram = "ejson2env";
  };
}
