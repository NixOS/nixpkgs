{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "maxfetch";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jobcmax";
    repo = "maxfetch";
    rev = "78bc0e11af523bb2c96500c04836977aea79d849";
    sha256 = "sha256-7R+6Ln3VazxMalocOqrrDNIHQJow+FigVTVvqFIrlQ8=";
  };

    installPhase = ''
        mkdir -p $out/bin
        chmod +x maxfetch
        cp maxfetch $out/bin
      '';

  meta = with lib; {
    description = "A fetching program written in shell";
    homepage = "https://github.com/jobcmax/maxfetch";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
