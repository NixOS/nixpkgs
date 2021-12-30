{ lib
, rustPlatform
, fetchCrate
, pkg-config
, installShellFiles
, fuse
, sandboxfs
, testVersion
}:

rustPlatform.buildRustPackage rec {
  pname = "sandboxfs";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-nrrkFYAf7HqaGFruolNTkXzy4ID6/vipxd+fOCKYARM=";
  };

  cargoSha256 = "sha256-izz10ePmEt2xxOyR4NODIMAcY9d4ODo677mq+DVf4RI=";

  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ fuse ];

  postInstall = "installManPage man/sandboxfs.1";

  passthru.tests.version = testVersion { package = sandboxfs; };

  meta = with lib; {
    description = "A virtual file system for sandboxing";
    homepage = "https://github.com/bazelbuild/sandboxfs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
