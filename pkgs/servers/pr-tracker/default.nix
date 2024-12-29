{ rustPlatform
, lib
, fetchzip
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "1.4.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-pCT74nAbtULvyS2BQ+XQU3LzF/q05wLaEeSa9j3DoAo=";
  };

  cargoHash = "sha256-WFI7eyr7fdQ6ePXQ+n/VrtPQ2eMZpVR68nGRBBlq3JU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl systemd ];

  meta = with lib; {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ qyliss sumnerevans ];
    mainProgram = "pr-tracker";
  };
}
