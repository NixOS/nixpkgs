{ stdenv, fetchurl }:

stdenv.mkDerivation rec {

  name = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/
  version = "0.20200720.0";

  src = fetchurl {
    url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/steam-runtime.tar.xz";
    sha256 = "03qdlr1xk84jb4c60ilis00vjhj70bxc0bbgk5g5b1883l2frljd";
    name = "scout-runtime-${version}.tar.gz";
  };

  buildCommand = ''
    mkdir -p $out
    tar -C $out --strip=1 -x -f $src
  '';

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = "https://github.com/ValveSoftware/steam-runtime";
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
