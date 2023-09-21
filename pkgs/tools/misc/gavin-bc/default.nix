{ lib
, stdenv
, fetchFromGitea
, editline
, readline
, historyType ? "internal"
, predefinedBuildType ? "BSD"
}:

assert lib.elem historyType [ "editline" "readline" "internal" ];
assert lib.elem predefinedBuildType [ "BSD" "GNU" "GDH" "DBG" "" ];
stdenv.mkDerivation (finalAttrs: {
  pname = "gavin-bc";
  version = "6.5.0";

  src = fetchFromGitea {
    domain = "git.gavinhoward.com";
    owner = "gavin";
    repo = "bc";
    rev = finalAttrs.version;
    hash = "sha256-V0L5OmpcI0Zu5JvESjuhp4wEs5Bu/CvjF6B5WllTEqo=";
  };

  buildInputs =
    (lib.optional (historyType == "editline") editline)
    ++ (lib.optional (historyType == "readline") readline);

  configureFlags = [
    "--disable-nls"
  ]
  ++ (lib.optional (predefinedBuildType != "") "--predefined-build-type=${predefinedBuildType}")
  ++ (lib.optional (historyType == "editline") "--enable-editline")
  ++ (lib.optional (historyType == "readline") "--enable-readline")
  ++ (lib.optional (historyType == "internal") "--enable-internal-history");

  meta = {
    homepage = "https://git.gavinhoward.com/gavin/bc";
    description = "Gavin Howard's BC calculator implementation";
    changelog = "https://git.gavinhoward.com/gavin/bc/raw/tag/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})
# TODO: cover most of configure settings
