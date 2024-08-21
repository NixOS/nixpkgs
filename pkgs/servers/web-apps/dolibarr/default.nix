{ stdenv, lib, fetchFromGitHub, nixosTests, stateDir ? "/var/lib/dolibarr" }:

stdenv.mkDerivation rec {
  pname = "dolibarr";
  version = "19.0.3";

  src = fetchFromGitHub {
    owner = "Dolibarr";
    repo = "dolibarr";
    rev = version;
    hash = "sha256-7LLlmJ5h8EmxPvRl+PJxAtjGRS44Zg8RQzwtoAsm6Kg=";
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
    description = "Enterprise resource planning (ERP) and customer relationship manager (CRM) server";
    homepage = "https://dolibarr.org/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
