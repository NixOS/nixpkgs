{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "0zp9bsa0kmg1rsvnxf93d2fnib0cyla0wxpd3sn9kmz20b0vblvn";
  };

  cargoSha256 = "17fnf61q32a0ljjna3lb0bafwhsll4zgwfwbcqh2ah5gfk1pwc92";

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
    maintainers = with maintainers; [ dywedir globin ma27 ];
    platforms = platforms.all;
  };
}
