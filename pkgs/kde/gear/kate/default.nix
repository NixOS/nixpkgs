{
  lib,
  mkKdeDerivation,
  project ? "kate",
}:
let
  inherit (lib) assertOneOf optionalString;
in
assert assertOneOf "project" project [
  "kate"
  "kwrite"
];
mkKdeDerivation {
  pname = "kate";

  postPatch =
    optionalString (project == "kate") ''
      substituteInPlace doc/CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(kwrite)' '''
      substituteInPlace apps/CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(kwrite)' '''
      for i in $(find 'po' -path '*/docs/*' -type d -name kwrite); do
        rm -rfv $i
      done
    ''
    + optionalString (project == "kwrite") ''
      substituteInPlace doc/CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(kate)' '''
      substituteInPlace doc/CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(katepart)' '''
      substituteInPlace apps/CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(kate)' '''
      substituteInPlace CMakeLists.txt --replace-fail 'ecm_optional_add_subdirectory(addons)' '''
      for i in $(find 'po' -path '*/docs/*' -type d \( -name katepart -o -name kate \)); do
        rm -rfv $i
      done
    '';

  meta = {
    mainProgram = project;
    maintainers = with lib.maintainers; [ sigmasquadron ];
  };
}
