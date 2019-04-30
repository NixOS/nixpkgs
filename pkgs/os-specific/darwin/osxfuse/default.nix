{ stdenv, runCommand, fetchFromGitHub, autoreconfHook }:

let
  version = "3.8.3";

  headers = runCommand "osxfuse-common-${version}" {
    src = fetchFromGitHub {
      owner = "osxfuse";
      repo = "osxfuse";
      rev = "osxfuse-${version}";
      sha256 = "13lmg41zcyiajh8m42w7szkbg2is4551ryx2ia2mmzvvd23pag0z";
    };
  } ''
    mkdir -p $out/include
    cp --target-directory=$out/include $src/common/*.h
  '';
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  pname = "osxfuse";
  inherit version;

  src = fetchFromGitHub {
    owner = "osxfuse";
    repo = "fuse";
    rev = "1a1977a"; # Submodule reference from osxfuse/osxfuse at tag osxfuse-${version}
    sha256 = "101fw8j40ylfbbrjycnwr5qp422agyf9sfbczyb9w5ivrkds3rfw";
  };

  postPatch = ''
    touch config.rpath
  '';

  postInstall = ''
    ln -s osxfuse.pc $out/lib/pkgconfig/fuse.pc
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ headers ];

  meta = with stdenv.lib; {
    homepage = https://osxfuse.github.io;
    description = "C-based FUSE for macOS SDK";
    platforms = platforms.darwin;
    license = licenses.gpl2;
  };
}
