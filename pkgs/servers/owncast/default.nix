{ lib, buildGoModule, fetchFromGitHub, nixosTests, bash, which, ffmpeg, makeWrapper, coreutils, ... }:

buildGoModule rec {
  pname = "owncast";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    sha256 = "sha256-hbZtdJbCB+67KXtApSRAO7Srye+UO0FbilKftQH6ESE=";
  };

  vendorSha256 = "sha256-sQRNf+eT9JUbYne/3E9LoY0K+c7MlxtIbGmTa3VkHvI=";

  propagatedBuildInputs = [ ffmpeg ];

  nativeBuildInputs = [ makeWrapper ];

  preInstall = ''
    mkdir -p $out
    cp -r $src/{static,webroot} $out
  '';

  postInstall = let

    setupScript = ''
      [ ! -d "$PWD/webroot" ] && (
        ${coreutils}/bin/cp --no-preserve=mode -r "${placeholder "out"}/webroot" "$PWD"
      )

      [ ! -d "$PWD/static" ] && (
        [ -L "$PWD/static" ] && ${coreutils}/bin/rm "$PWD/static"
        ${coreutils}/bin/ln -s "${placeholder "out"}/static" "$PWD"
      )
    '';
  in ''
    wrapProgram $out/bin/owncast \
      --run '${setupScript}' \
      --prefix PATH : ${lib.makeBinPath [ bash which ffmpeg ]}
  '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/owncast --help
    runHook postCheck
  '';

  passthru.tests.owncast = nixosTests.testOwncast;

  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ MayNiklas ];
  };

}
