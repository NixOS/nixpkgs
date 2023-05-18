{ lib
, buildGoModule
, fetchFromGitHub
, unstableGitUpdater
}:

buildGoModule rec {
  pname = "tewisay";
  version = "unstable-2022-11-04";

  # lucy deleted the old repo, this is a fork/mirror
  src = fetchFromGitHub {
    owner = "raymond-w-ko";
    repo = "tewisay";
    rev = "caa5b0131dda868f656716d2107f02d04d1048d4";
    hash = "sha256-E492d8P/Bek9xZlJP+k9xvIJEFtA1YrIB/pogvz3wM4=";
  };

  vendorHash = "sha256-WcpRJ31kqWA255zfjuWDj0honJgSGdm4ONx2yOKk7/g=";

  # Currently hard-coded, will be fixed by developer
  postPatch = ''
    substituteInPlace main.go \
      --replace "/usr" "$out"
  '';

  postInstall = ''
    mkdir -p $out/share
    mv {cows,zsh} $out/share
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/raymond-w-ko/tewisay";
    description = "Cowsay replacement with unicode and partial ansi escape support";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ Madouura ];
  };
}
