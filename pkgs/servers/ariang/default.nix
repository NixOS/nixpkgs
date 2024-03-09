{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, nix-update-script
}:

buildNpmPackage rec {
  pname = "ariang";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-p9EwlmI/xO3dX5ZpbDVVxajQySGYcJj5G57F84zYAD0=";
  };

  npmDepsHash = "sha256-xX8hD303CWlpsYoCfwHWgOuEFSp1A+M1S53H+4pyAUQ=";

  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/ariang

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "a modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };
}
