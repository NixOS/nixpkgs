{ lib, stdenvNoCC, fetchFromGitHub, bash, makeWrapper, pciutils
, x11Support ? true, ueberzug, fetchpatch
}:

stdenvNoCC.mkDerivation rec {
  pname = "neofetch";
  version = "unstable-2020-11-26";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "6dd85d67fc0d4ede9248f2df31b2cd554cca6c2f";
    sha256 = "sha256-PZjFF/K7bvPIjGVoGqaoR8pWE6Di/qJVKFNcIz7G8xE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dylanaraps/neofetch/commit/413c32e55dc16f0360f8e84af2b59fe45505f81b.patch";
      sha256 = "1fapdg9z79f0j3vw7fgi72b54aw4brn42bjsj48brbvg3ixsciph";
      name = "avoid_overwriting_gio_extra_modules_env_var.patch";
    })
  ];

  strictDeps = true;
  buildInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${lib.makeBinPath ([ pciutils ] ++ lib.optional x11Support ueberzug) }
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "A fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ alibabzo konimex ];
    mainProgram = "neofetch";
  };
}
