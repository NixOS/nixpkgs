{ stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true, fzf
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "1zfk9y5f12h2d5zwf2z8c95xwhbhc6ayv971875fbxgz1nd8vqb6";
  };

  postPatch = stdenv.lib.optionalString withFzf ''
    substituteInPlace src/fzf.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "0z0p3cxxazw19bmk3zw7z2q93p00ywsa2cz1jhy78mn5pq1v95rd";

  meta = with stdenv.lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
