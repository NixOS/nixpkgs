{ lib, fetchFromGitHub, cmake }: rec {
  # Fetching stuff
  version = "6.13.0";
  # as long as this function is used, you will always fetch the same release of all components
  fetchKurento = { repo, sha256, extraPostFetch ? "", rev ? version }: fetchFromGitHub {
    inherit repo sha256 extraPostFetch rev;
    owner = "Kurento";
  };

  # Cmake stuff
  cmakeVersion = "cmake-" + lib.versions.majorMinor cmake.version;
  mkCmakeModules = pkgs: [ ("-DCMAKE_MODULE_PATH=" + (lib.concatStringsSep ";" (map (pkg: "${pkg}/share/${cmakeVersion}/Modules") pkgs))) ];
}
