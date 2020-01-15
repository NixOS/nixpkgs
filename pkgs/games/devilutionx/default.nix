{ stdenv, fetchFromGitHub, cmake, SDL2, SDL2_mixer, SDL2_ttf, libsodium, pkg-config }:
stdenv.mkDerivation {
  version = "unstable-2019-07-28";
  pname = "devilutionx";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    rev = "b2f358874705598ec139f290b21e340c73d250f6";
    sha256 = "0s812km118qq5pzlzvzfndvag0mp6yzvm69ykc97frdiq608zw4f";
  };

  NIX_CFLAGS_COMPILE = "-I${SDL2_ttf}/include/SDL2";

  # compilation will fail due to -Werror=format-security
  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ libsodium SDL2 SDL2_mixer SDL2_ttf ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp devilutionx $out/bin

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/diasurgical/devilutionX";
    description = "Diablo build for modern operating systems";
    license = licenses.unlicense;
    maintainers = [ maintainers.karolchmist ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
