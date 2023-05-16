{ lib
, fetchFromSourcehut
, rustPlatform
, pkg-config
, libxkbcommon
, makeWrapper
, slurp
}:

rustPlatform.buildRustPackage rec {
  pname = "shotman";
<<<<<<< HEAD
  version = "0.4.5";
=======
  version = "0.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SctWNhYCFTAOOnDEcsFZH61+QQAcmup11GVVXA1U5Dw=";
  };

  cargoHash = "sha256-q5scdgfB5NgtjAgnIy/+c+y/mymF0b9ZZSz2LmM0pfw=";
=======
    hash = "sha256-u8vnRNxi7wLn0M2VZu9YTZuSAM/0afHRP01vve9tD9c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-client-toolkit-0.16.0" = "sha256-n+s+qH39tna0yN44D6GGlQGZHjsr9FBpp+NZItyqwaE=";
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ libxkbcommon ];

  preFixup = ''
    wrapProgram $out/bin/shotman \
      --prefix PATH ":" "${lib.makeBinPath [ slurp ]}";
  '';

  meta = with lib; {
    description = "The uncompromising screenshot GUI for Wayland compositors";
    homepage = "https://git.sr.ht/~whynothugo/shotman";
    license = licenses.isc;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ zendo fpletz ];
=======
    maintainers = with maintainers; [ zendo ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
