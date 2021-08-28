{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "00vlifbri021z8nf7xvbaay8mqvnq58h19va9bqr5lhsqj1f82wq";
  };

  cargoSha256 = "0n6xqd30b8aiqrvqrmy7q56nh62nx2j1a3yq2dlpc19i2mfw2qd8";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage doc/fd.1

    installShellCompletion $releaseDir/build/fd-find-*/out/fd.{bash,fish}
    installShellCompletion --zsh contrib/completion/_fd
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
  };
}
