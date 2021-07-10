{ expect, fetchFromGitHub, lib, rustPlatform, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "fcp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "svetlitski";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ahd79dh48hsi4bhs4zs0a7hr55jzsjix9c61lc42ipdbqgifg2d";
  };

  cargoSha256 = "1arrw4fz3f3wfjy9nb8vm707vhh4x0vv9wv8z2s07b4qcwwih8k4";

  nativeBuildInputs = [ expect ];

  # character_device fails with "File name too long" on darwin
  doCheck = !stdenv.isDarwin;

  postPatch = ''
    patchShebangs tests/*.exp
  '';

  meta = with lib; {
    description = "A significantly faster alternative to the classic Unix cp(1) command";
    homepage = "https://github.com/svetlitski/fcp";
    changelog = "https://github.com/svetlitski/fcp/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
