{ lib, stdenv, fetchFromGitHub, libgcrypt
, pkg-config, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite
, util-linux }:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    hash = "sha256-D3+p8XgokKIHEwZnvOkn7cionVH1gsypcURF+PBpugY=";
  };

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
