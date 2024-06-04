{ stdenv
, lib
, fetchFromBitbucket
, cmake
, pkg-config
, makeWrapper
, zlib
, bzip2
, libjpeg
, SDL2
, SDL2_net
, SDL2_mixer
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "ecwolf";
  version = "1.4.1";

  src = fetchFromBitbucket {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "V2pSP8i20zB50WtUMujzij+ISSupdQQ/oCYYrOaTU1g=";
  };

  nativeBuildInputs = [ cmake pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ makeWrapper ];
  buildInputs = [ zlib bzip2 libjpeg SDL2 SDL2_net SDL2_mixer gtk3 ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework AppKit";

  # ECWolf installs its binary to the games/ directory, but Nix only adds bin/
  # directories to the PATH.
  postInstall = lib.optionalString stdenv.isLinux ''
    mv "$out/games" "$out/bin"
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R ecwolf.app $out/Applications
    makeWrapper $out/{Applications/ecwolf.app/Contents/MacOS,bin}/ecwolf
  '';

  meta = with lib; {
    description = "Enhanched SDL-based port of Wolfenstein 3D for various platforms";
    mainProgram = "ecwolf";
    homepage = "https://maniacsvault.net/ecwolf/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jayman2000 sander ];
    platforms = platforms.all;
  };
}
