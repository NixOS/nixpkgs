{ buildPerlPackage, stdenv, lib, fetchFromGitHub, which, bzip2, PodMarkdown, JSONXS
<<<<<<< HEAD
, TextCSV_XS }:
buildPerlPackage rec {
  pname = "pgbadger";
  version = "12.2";
  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    rev = "v${version}";
    hash = "sha256-IzfpDqzS5VcehkPsFxyn3kJsvXs8nLgJ3WT8ZCmIDxI=";
=======
, TextCSV }:
buildPerlPackage rec {
  pname = "pgbadger";
  version = "11.5";
  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    rev = "98b38161ba99faae77c81d5fa47bd769c1dd750b";
    sha256 = "0r01mx1922g1m56x4958cihk491zjlaijvap0i32grjmnv4s5v88";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  outputs = [ "out" ];

  PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

<<<<<<< HEAD
  buildInputs = [ PodMarkdown JSONXS TextCSV_XS ];
=======
  buildInputs = [ PodMarkdown JSONXS TextCSV ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ which bzip2 ];

  meta = {
    homepage = "https://github.com/darold/pgbadger";
    description = "A fast PostgreSQL Log Analyzer";
<<<<<<< HEAD
    changelog = "https://github.com/darold/pgbadger/raw/v${version}/ChangeLog";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.postgresql;
    maintainers = lib.teams.determinatesystems.members;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pgbadger.x86_64-darwin
  };
}
