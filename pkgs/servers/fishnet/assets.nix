{ lib
, stdenv
, fetchFromGitHub
, xz
, autoPatchelfHook }:

# Assets for fishnet: A collection of pre-built compressed stockfish binaries.
# We have to decompress them, patch them using auto-patchelf and compress them
# again so that a selection of them can be embedded into the fishnet binary.
stdenv.mkDerivation rec {
  pname = "fishnet-assets";
  version = "unstable-2020-01-30";

  src = fetchFromGitHub {
    owner = "niklasf";
    repo = pname;
    rev = "b4fa30e57ec8976fb1c10bd36737bc784351b93e";
    sha256 = "0gfs9lm4ih3h3fmgqylw05ii1h0d6mpjfxadnw3wymnjsspfb0m4";
  };

  relAssetsPath = "share/${pname}";

  nativeBuildInputs = [ xz autoPatchelfHook ];

  postPatch = ''
    # Delete packed .exe files and all non .xz files (documentation and readme)
    rm *.exe.xz
    find \! -name "*.xz" -delete
    # Extract .xz files, except *.nnue.xz
    # We don't have to unpack the latter and it takes ages to repack
    find -name "*.xz" \! -name "*.nnue.xz" | xargs unxz -v
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/${relAssetsPath}
    cp ./* $out/${relAssetsPath}
  '';

  preFixup = ''
    gatherLibraries '${stdenv.cc.cc.lib}'
  '';

  doDist = true;
  distPhase = ''
    # repack assets
    find $out/${relAssetsPath} -type f \! -name "*.xz" | xargs xz -v
  '';

  meta = with lib; {
    description = "Assets for fishnet, only required during build";
    homepage = "https://github.com/niklasf/fishnet-assets";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tu-maurice ];
  };
}
