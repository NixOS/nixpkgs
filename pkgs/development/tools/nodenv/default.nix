{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "nodenv";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nodenv";
    repo = "nodenv";
    rev = "v${version}";
    sha256 = "0fgc23jd95rjll3dy5hnli8ksfc7rwscw53sdgss4yaharwlg8l2";
  };

  buildPhase = ''
    runHook preBuild

    bash src/configure
    make -C src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r libexec $out/
    cp -r bin $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Manage multiple NodeJS versions";
    homepage = "https://github.com/nodenv/nodenv/";
    changelog = "https://github.com/nodenv/nodenv/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
