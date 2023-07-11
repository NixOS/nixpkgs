{ lib
, stdenv
, fetchurl
, pkg-config
, python3
, flex
, sqlite
, libedit
, runCommand
, dieHook
}:

let

link-grammar = stdenv.mkDerivation rec {
  pname = "link-grammar";
  version = "5.10.5";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchurl {
    url = "http://www.abisource.com/downloads/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-MkcQzYEyl1/5zLU1CXMvdVhHOxwZ8XiSAAo97bhhiu0=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    flex
  ];

  buildInputs = [
    sqlite
    libedit
  ];

  configureFlags = [
    "--disable-java-bindings"
  ];

  doCheck = true;

  passthru.tests = {
    quick = runCommand "link-grammar-quick-test" {
      buildInputs = [
        link-grammar
        dieHook
      ];
    } ''
      echo "Furiously sleep ideas green colorless." | link-parser en | grep "No complete linkages found." || die "Grammaticaly invalid sentence was parsed."
      echo "Colorless green ideas sleep furiously." | link-parser en | grep "Found .* linkages." || die "Grammaticaly valid sentence was not parsed."
      touch $out
    '';
  };

  meta = with lib; {
    description = "A Grammar Checking library";
    homepage = "https://www.abisource.com/projects/link-grammar/";
    changelog = "https://github.com/opencog/link-grammar/blob/link-grammar-${version}/ChangeLog";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
};

in
  link-grammar
