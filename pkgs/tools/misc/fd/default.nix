{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "108p1p9bxhg4qzwfs6wqcakcvlpqw3w498jkz1vhmg6jp1mbmgdr";
  };

  cargoSha256 = "1nhlarrl0m6as3j2547yf1xxjm88qy3v8jgvhd47z3f5s63bb6w5";

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
