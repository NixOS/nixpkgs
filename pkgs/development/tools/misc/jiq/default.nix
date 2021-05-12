{ lib, buildGoModule, fetchFromGitHub, jq, makeWrapper }:

buildGoModule rec {
  pname = "jiq";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "fiatjaf";
    repo = pname;
    rev = version;
    sha256 = "sha256-EPhnfgmn0AufuxwcwRrEEQk+RD97akFJSzngkTl4LmY=";
  };

  vendorSha256 = "sha256-ZUmOhPGy+24AuxdeRVF0Vnu8zDGFrHoUlYiDdfIV5lc=";

  nativeBuildInputs = [ makeWrapper ];

  checkInputs = [ jq ];

  postInstall = ''
    wrapProgram $out/bin/jiq \
      --prefix PATH : ${lib.makeBinPath [ jq ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/fiatjaf/jiq";
    license = licenses.mit;
    description = "jid on jq - interactive JSON query tool using jq expressions";
    maintainers = with maintainers; [ ma27 ];
  };
}
