{ lib
, buildGoModule
, makeWrapper
, fetchFromGitHub
, playerctl
}:
buildGoModule rec {
  pname = "pww";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "abenz1267";
    repo = "pww";
    rev = "v${version}";
    hash = "sha256-nqNSzipOa0gj9qF49f/1R5QZMSY9xmjBnAVkiXdrSa4=";
  };

  vendorSha256 = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : "${lib.makeBinPath [ playerctl ]}"
  '';

  meta = with lib; {
    description = "Utility wrapper around playerctl";
    homepage = "https://github.com/abenz1267/pww";
    changelog = "https://github.com/abenz1267/pww/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ therealr5 ];
    platforms = platforms.unix;
  };
}
