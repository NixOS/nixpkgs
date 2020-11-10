{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper
, nixosTests, rclone }:

buildGoModule rec {
  pname = "restic";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "restic";
    repo = "restic";
    rev = "v${version}";
    sha256 = "13zmx9wzv29z0np3agx4rsz1j9pgrvlnngjsb971i1dnzwv5l3hf";
  };

  vendorSha256 = "09sa5jpdj73w595c063mib14132zacswh54nmjqp2n440cflmwjh";

  subPackages = [ "cmd/restic" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  passthru.tests.restic = nixosTests.restic;

  postPatch = ''
    rm cmd/restic/integration_fuse_test.go
  '';

  postInstall = ''
    wrapProgram $out/bin/restic --prefix PATH : '${rclone}/bin'
  '' + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    $out/bin/restic generate \
      --bash-completion restic.bash \
      --zsh-completion restic.zsh \
      --man .
    installShellCompletion restic.{bash,zsh}
    installManPage *.1
  '';

  meta = with lib; {
    homepage = "https://restic.net";
    description = "A backup program that is fast, efficient and secure";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd2;
    maintainers = [ maintainers.mbrgm ];
  };
}
