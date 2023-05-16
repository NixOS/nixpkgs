<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, bash
, which
, ffmpeg
, makeBinaryWrapper
}:

let
  version = "0.1.1";
in buildGoModule {
  pname = "owncast";
  inherit version;
=======
{ lib, buildGoModule, fetchFromGitHub, nixosTests, bash, which, ffmpeg, makeWrapper, coreutils, ... }:

buildGoModule rec {
  pname = "owncast";
  version = "0.0.13";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nBTuvVVnFlC75p8bRCN+lNl9fExBZrsLEesvXWwNlAQ=";
  };
  vendorHash = "sha256-yjy5bDJjWk7UotBVqvVFiGx8mpfhpqMTxoQm/eWHcw4=";

  propagatedBuildInputs = [ ffmpeg ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/owncast \
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
