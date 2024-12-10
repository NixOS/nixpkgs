{
  stdenv,
  lib,
  fetchFromGitHub,
  nixosTests,
  stateDir ? "/var/lib/dolibarr",
}:

stdenv.mkDerivation rec {
  pname = "dolibarr";
  version = "19.0.2";

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    rev = version;
    hash = "sha256-HPAcDgJSh3oIrr0vI9C80NR6oDS1KbAiiYR1tL5qrrI=";
  };

  dontBuild = true;

  postPatch = ''
    find . -type f -name "*.php" -print0 | xargs -0 sed -i 's|/etc/dolibarr|${stateDir}|g'

    substituteInPlace htdocs/filefunc.inc.php \
      --replace '//$conffile = ' '$conffile = ' \
      --replace '//$conffiletoshow = ' '$conffiletoshow = '

    substituteInPlace htdocs/install/inc.php \
      --replace '//$conffile = ' '$conffile = ' \
      --replace '//$conffiletoshow = ' '$conffiletoshow = '
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r * $out
  '';

  passthru.tests = { inherit (nixosTests) dolibarr; };

  meta = with lib; {
    description = "A enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    homepage = "https://dolibarr.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
