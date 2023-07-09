{ lib, stdenv, makeWrapper, fetchpatch, fetchFromGitea, python3, zlib, strace
, libGLU, SDL, pkg-config, lua5_1, libpng, libtheora, libvorbis }:

stdenv.mkDerivation rec {
  pname = "boswars";
  version = "2.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-UXPHDwuAoBK862slmQdWWXuu8odlpfGwe40HvUzm42c=";
  };

  nativeBuildInputs =
    [ makeWrapper strace python3 pkg-config zlib libGLU SDL lua5_1 libpng ];

  buildFlags = [ "STRATAGUS_LIB_PATH=$out/share/${pname}" ];

  buildPhase = ''
    python make.py release
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share

    # data
    install -d "$out"/share/${pname}/languages
    python make.py install_data datadir=$out/share/${pname}

    # binary
    install -Dm755 fbuild/release/${pname} $out/bin/${pname}
  '';

  meta = {
    description =
      "A futuristic real-time strategy game featuring a dynamic rate-based economy.";
    longDescription = ''
      Bos Wars is a futuristic real-time strategy game featuring a dynamic rate-based economy. Resources are continuously produced while also being consumed by creating buildings and training new units. Bos Wars aims to create a completely original and fun open source RTS game.
    '';
    homepage = "www.boswars.com";
    license = with lib.licenses; [
      gpl2 # Code
      gpl2Plus # Assets
    ];
    maintainers = with lib.maintainers; [ rampoina ];
    platforms = lib.platforms.linux;
  };
}
