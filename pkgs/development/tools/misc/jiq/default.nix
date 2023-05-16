{ lib, buildGoModule, fetchFromGitHub, jq, makeWrapper }:

buildGoModule rec {
  pname = "jiq";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-txhttYngN+dofA3Yp3gZUZPRRZWGug9ysXq1Q0RP7ig=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-ZUmOhPGy+24AuxdeRVF0Vnu8zDGFrHoUlYiDdfIV5lc=";
=======
  vendorSha256 = "sha256-ZUmOhPGy+24AuxdeRVF0Vnu8zDGFrHoUlYiDdfIV5lc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ jq ];

  postInstall = ''
    wrapProgram $out/bin/jiq \
      --prefix PATH : ${lib.makeBinPath [ jq ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/fiatjaf/jiq";
    license = licenses.mit;
    description = "jid on jq - interactive JSON query tool using jq expressions";
    maintainers = with maintainers; [ ];
  };
}
