{ lib
, stdenv
, fetchFromGitea
, editline
, readline
, historyType ? "internal"
, predefinedBuildType ? "BSD"
}:

assert lib.elem historyType [ "editline" "readline" "internal" ];
assert lib.elem predefinedBuildType [ "BSD" "GNU" "GDH" "DBG" ];
stdenv.mkDerivation (self: {
  pname = "gavin-bc";
  version = "6.2.4";

  src = fetchFromGitea {
    domain = "git.gavinhoward.com";
    owner = "gavin";
    repo = "bc";
    rev = self.version;
    hash = "sha256-KQheSyBbxh2ROOvwt/gqhJM+qWc+gDS/x4fD6QIYUWw=";
  };

  buildInputs =
    (lib.optional (historyType == "editline") editline)
    ++ (lib.optional (historyType == "readline") readline);

  configureFlags = [
    "--disable-nls"
    "--predefined-build-type=${historyType}"
  ]
  ++ (lib.optional (historyType == "editline") "--enable-editline")
  ++ (lib.optional (historyType == "readline") "--enable-readline");

  meta = {
    homepage = "https://git.gavinhoward.com/gavin/bc";
    description = "Gavin Howard's BC calculator implementation";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
