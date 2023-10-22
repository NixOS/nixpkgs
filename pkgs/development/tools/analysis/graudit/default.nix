{ lib
, stdenv
, fetchFromGitHub
, groff
, which
, zip
}:

stdenv.mkDerivation rec {
  pname = "graudit";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "wireghoul";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VgXlOVACvIOQJSXKsR27yL6R3QWoaKZc/t+bt+gP4gk=";
  };

  buildInputs = [ groff which zip ];

  patches = [
    ./fix-lib-path.patch
    ./remove-fixed-prefix.patch
    ./remove-git-test.patch
  ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "grep rough audit - source code auditing tool";
    longDescription = ''
      A simple script and signature sets that allows you to
      find potential security flaws in source code using the GNU
      utility grep.
    '';
    homepage = "https://github.com/wireghoul/graudit";
    changelog = "https://github.com/wireghoul/graudit/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.jaybosamiya ];
    platforms = platforms.all;
  };
}
