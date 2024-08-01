{ lib, stdenv, cmake, fetchFromGitLab
, json_c, libsodium, libxml2, ncurses }:

let
  rev = "22796663dcad81684ab24308d9db570f6781ba2c";

in stdenv.mkDerivation rec {
  name = "mpw-${version}-${builtins.substring 0 8 rev}";
  version = "2.6";

  src = fetchFromGitLab {
    owner  = "MasterPassword";
    repo   = "MasterPassword";
    sha256 = "1f2vqacgbyam1mazawrfim8zwp38gnwf5v3xkkficsfnv789g6fw";
    inherit rev;
  };

  sourceRoot = "${src.name}/platform-independent/c/cli";

  postPatch = ''
    rm build
    substituteInPlace mpw-cli-tests \
      --replace '/usr/bin/env bash' ${stdenv.shell} \
      --replace ./mpw ./build/mpw
  '';

  cmakeFlags = [
    "-Dmpw_version=${version}"
    "-DBUILD_MPW_TESTS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ json_c libxml2 libsodium ncurses ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mpw                    $out/bin/mpw
    install -Dm644 ../mpw.completion.bash $out/share/bash-completion/completions/_mpw
    install -Dm644 ../../../../README.md  $out/share/doc/mpw/README.md

    runHook postInstall
  '';

  # Some tests are expected to fail on ARM64
  # See: https://gitlab.com/spectre.app/cli/-/issues/27#note_962950844 (mpw is a predecessor to spectre-cli and this issue is relevant to mpw as well)
  doCheck = !(stdenv.isLinux && stdenv.isAarch64);

  checkPhase = ''
    runHook preCheck

    ../mpw-cli-tests

    runHook postCheck
  '';

  meta = with lib; {
    description = "Stateless password management solution";
    mainProgram = "mpw";
    homepage = "https://masterpasswordapp.com/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
