{ stdenv, lib, nixos-container, openssh, glibcLocales, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "extra-container";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "erikarvstedt";
    repo = pname;
    rev = version;
    hash = "sha256-/5wPv962ZHvZoZMOr4nMz7qcvbzlExRYS2nrnay/PU8=";
  };

  buildCommand = ''
    install -D $src/extra-container $out/bin/extra-container
    patchShebangs $out/bin
    share=$out/share/extra-container
    install $src/eval-config.nix -Dt $share

    # Use existing PATH for systemctl and machinectl
    scriptPath="export PATH=${lib.makeBinPath [ openssh ]}:\$PATH"

    sed -i "
      s|evalConfig=.*|evalConfig=$share/eval-config.nix|
      s|LOCALE_ARCHIVE=.*|LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive|
      2i$scriptPath
      2inixosContainer=${nixos-container}/bin
    " $out/bin/extra-container
  '';

  meta = with lib; {
    description = "Run declarative containers without full system rebuilds";
    homepage = "https://github.com/erikarvstedt/extra-container";
    changelog = "https://github.com/erikarvstedt/extra-container/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.erikarvstedt ];
  };
}
