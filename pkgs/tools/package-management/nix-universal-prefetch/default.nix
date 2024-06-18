{ lib, stdenv
, fetchFromGitHub
, ruby
}:

# No gems used, so mkDerivation is fine.
stdenv.mkDerivation rec {
  pname = "nix-universal-prefetch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "nix-universal-prefetch";
    rev = "v${version}";
    sha256 = "sha256-HGn4qHWqpUwlS3yQrD3j5oH0yOlphsoSPD2vkyyRv+0=";
  };

  installPhase = ''
    mkdir -pv $out/bin
    cp nix-universal-prefetch $out/bin/nix-universal-prefetch
    substituteInPlace "$out/bin/nix-universal-prefetch" \
      --replace "/usr/bin/env nix-shell" "${ruby}/bin/ruby"
  '';

  meta = with lib; {
    description = "Uses nixpkgs fetchers to figure out hashes";
    homepage = "https://github.com/samueldr/nix-universal-prefetch";
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "nix-universal-prefetch";
  };
}
