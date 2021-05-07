{ lib
, fetchFromGitHub
, rustPlatform
, fuse
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "sandboxfs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "sandboxfs-${version}";
    sha256 = "Ia6rq6FN4abnvLXjlQh4Q+8ra5JThKnC86UXC7s9//U=";
  };

  cargoSha256 = "sha256-fAPMAVvcI3pm3zTLATO7SUdZpG469fjlBZshFhgv6gY=";

  # Issue to add Cargo.lock upstream: https://github.com/bazelbuild/sandboxfs/pull/115
  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ fuse ];

  postInstall = "installManPage man/sandboxfs.1";

  meta = with lib; {
    description = "A virtual file system for sandboxing";
    homepage = "https://github.com/bazelbuild/sandboxfs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
