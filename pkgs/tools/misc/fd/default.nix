{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "029xr7l751dy167hfzrd030llkaiy8j585h1d4l6391fgrsvnav7";
  };

  cargoSha256 = "0lq6da2f6xywyhzyyrpph96d8b9vpdzakzipci167g6hhh232b5b";

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
