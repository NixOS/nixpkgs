{ lib, stdenv, fetchFromGitHub, pkg-config, R, postgresql }:

stdenv.mkDerivation rec {
  pname = "plr";
  version = "8.4.1";

  src = fetchFromGitHub {
    owner = "postgres-plr";
    repo = "plr";
    rev = "REL${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "1wy4blg8jl30kzhrkvbncl4gmy6k71zipnq89ykwi1vmx89v3ab7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ R postgresql ];
  preBuild = ''
    export USE_PGXS=1
  '';
  installPhase = ''
    install -D plr.so -t $out/lib/
    install -D {plr--unpackaged--8.4.1.sql,plr--8.4.1.sql,plr.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "PL/R - R Procedural Language for PostgreSQL";
    homepage = "https://github.com/postgres-plr/plr";
    maintainers = with maintainers; [ qoelet ];
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl2Only;
  };
}
