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
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u8vnRNxi7wLn0M2VZu9YTZuSAM/0afHRP01vve9tD9c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-client-toolkit-0.16.0" = "sha256-n+s+qH39tna0yN44D6GGlQGZHjsr9FBpp+NZItyqwaE=";
    };
  };

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
    maintainers = with maintainers; [ zendo ];
  };
}
