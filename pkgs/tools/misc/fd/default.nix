{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "0qzqnsjkq8i4gzn9273algx33kr1hzgxid8lnqp4awy2zxm4ksiq";
  };

  cargoSha256 = "1d7hfgl9l4b9bnq2qcpvdq5rh7lpz33r19hw3wwgnqh142q67m7r";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage "$src/doc/fd.1"

    installShellCompletion $releaseDir/build/fd-find-*/out/fd.{bash,fish}
    installShellCompletion --zsh $releaseDir/build/fd-find-*/out/_fd
  '';

  meta = with lib; {
    description = "A simple, fast and user-friendly alternative to find";
    longDescription = ''
      `fd` is a simple, fast and user-friendly alternative to `find`.

      While it does not seek to mirror all of `find`'s powerful functionality,
      it provides sensible (opinionated) defaults for 80% of the use cases.
    '';
    homepage = "https://github.com/sharkdp/fd";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir globin ma27 zowoq ];
    platforms = platforms.all;
  };
}
