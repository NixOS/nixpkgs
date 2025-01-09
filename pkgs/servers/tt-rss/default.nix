{
  lib,
  stdenv,
  fetchgit,
  nixosTests,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "0-unstable-2024-12-22";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "fc89d2e6333d6d828f2b07a53be53677caf3d638";
    hash = "sha256-z+sWplOExqtkWPEBJ+WOb4CPDX1iLj14KwrGSojFp0A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "${version}" > $out/version_static.txt

    runHook postInstall
  '';

  passthru = {
    inherit (nixosTests) tt-rss;
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [
      gileri
      globin
      zohl
    ];
    platforms = platforms.all;
  };
}
