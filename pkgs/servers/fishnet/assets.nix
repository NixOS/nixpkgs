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
    rev = "acd36ab6ccee67a652b6d84aedc4c2828abac5c6";
    sha256 = "0mh4gh6qij70clp64m4jw6q7dafr7gwjqpvpaf9vc6h10g1rhzrx";
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
    platforms = [ "x86_64-linux" ];
  };
}
