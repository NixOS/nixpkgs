{ buildPerlPackage, stdenv, lib, fetchFromGitHub, which, bzip2, PodMarkdown, JSONXS
, TextCSV }:
buildPerlPackage rec {
  pname = "pgbadger";
  version = "11.5";
  src = fetchFromGitHub {
    owner = "darold";
    repo = "pgbadger";
    rev = "98b38161ba99faae77c81d5fa47bd769c1dd750b";
    sha256 = "0r01mx1922g1m56x4958cihk491zjlaijvap0i32grjmnv4s5v88";
  };

  postPatch = ''
    patchShebangs ./pgbadger
  '';

  outputs = [ "out" ];

  PERL_MM_OPT = "INSTALL_BASE=${placeholder "out"}";

  buildInputs = [ PodMarkdown JSONXS TextCSV ];

  checkInputs = [ which bzip2 ];

  meta = {
    homepage = "https://github.com/darold/pgbadger";
    description = "A fast PostgreSQL Log Analyzer";
    license = lib.licenses.postgresql;
    maintainers = lib.teams.determinatesystems.members;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/pgbadger.x86_64-darwin
  };
}
