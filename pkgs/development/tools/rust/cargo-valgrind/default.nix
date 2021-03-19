{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, makeWrapper
, valgrind
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-valgrind";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jfrimmel";
    repo = "cargo-valgrind";
    # repo lacks the 2.0.0 tag
    # https://github.com/jfrimmel/cargo-valgrind/issues/33
    rev = "d47dd810e3971d676cde5757df8b2e05ed563e41";
    sha256 = "163ch5bpwny1di758rpfib1ddqclxm48j0lmmv741ji3l4nqid32";
  };

  cargoSha256 = "sha256-nFc5xqYZ4Jb/0NIuhUbkvs+p+l5OScKwJVewwZF+ff0=";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-valgrind --prefix PATH : ${lib.makeBinPath [ valgrind ]}
  '';

  meta = with lib; {
    description = ''Cargo subcommand "valgrind": runs valgrind and collects its output in a helpful manner'';
    homepage = "https://github.com/jfrimmel/cargo-valgrind";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
