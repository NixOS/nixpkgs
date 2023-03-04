{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zplug";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "zplug";
    repo = pname;
    rev = version;
    sha256 = "0hci1pbs3k5icwfyfw5pzcgigbh9vavprxxvakg1xm19n8zb61b3";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = with lib; {
    description = "A next-generation plugin manager for zsh";
    homepage = "https://github.com/zplug/zplug";
    license = licenses.mit;
    maintainers = [ maintainers.s1341 ];
    mainProgram = "zplug-env";
    platforms = platforms.all;
  };
}
