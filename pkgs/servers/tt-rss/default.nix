{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "unstable-2022-08-01";
  rev = "cd26dbe64c9b14418f0b2d826a38a35c6bf8a270";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "ed2cbeffcc456a86726b52d37c977a35b895968c";
    sha256 = "0ab1q316y4f432z2kwn86kc144awk529cild7b4jbffh2ydlj3r4";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "22.08" > $out/version_static.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
