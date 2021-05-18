{ lib, stdenv, fetchFromGitLab }:

stdenv.mkDerivation rec {
  pname = "yafetch";
  version = "unstable-2021-05-13";

  src = fetchFromGitLab {
    owner = "cyberkitty";
    repo = pname;
    rev = "627465e6bf0192a9bc10f9c9385cde544766486f";
    sha256 = "1r8jnzfyjs5ardq697crwysclfm3k8aiqvfbsyhsl251a08yls5c";
  };

  # Use the provided NixOS logo automatically
  prePatch = ''
    echo "#include \"ascii/nixos.h\"" > config.h
  '';

  # Fixes installation path
  DESTDIR = placeholder "out";

  meta = with lib; {
    homepage = "https://gitlab.com/cyberkitty/yafetch";
    description = "Yet another fetch clone written in C++";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.linux;
  };
}
