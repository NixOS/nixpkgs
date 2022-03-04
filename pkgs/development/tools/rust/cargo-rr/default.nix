{ lib
, rustPlatform
, fetchFromGitHub
, genericUpdater
, common-updater-scripts
, makeWrapper
, rr
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rr";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "danielzfranklin";
    repo = pname;
    rev = version;
    sha256 = "01m8fdz9as2fxnzs9csvbc76qxzbb98a66dh7w4a5q855v38g0zy";
  };

  cargoSha256 = "0fjs76n6bbbv83s213h2dgsszgxy4hbjsclyk9m81b3bfbmmb9sa";

  passthru = {
    updateScript = genericUpdater {
      inherit pname version;
      versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-rr --prefix PATH : ${lib.makeBinPath [ rr ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand \"rr\": a light wrapper around rr, the time-travelling debugger";
    homepage = "https://github.com/danielzfranklin/cargo-rr";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
