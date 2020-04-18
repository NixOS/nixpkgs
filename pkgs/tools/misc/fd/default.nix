{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "0l18xavkj99cydp1dqrph00yq2px339zs6jcim59iq3zln1yn0n7";
  };

  cargoSha256 = "1sdwbnncs1d45x1iqk3jv3r69fpkzrsxm4kjn89jmvd5nk8blvs2";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage "$src/doc/fd.1"

    (cd target/release/build/fd-find-*/out
    installShellCompletion fd.{bash,fish}
    installShellCompletion --zsh _fd)
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
    maintainers = with maintainers; [ dywedir globin ma27 ];
    platforms = platforms.all;
  };
}
