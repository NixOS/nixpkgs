{ stdenv, fetchFromGitHub, python3Packages, btrfs-progs }:

let
  our-btrfs-progs = btrfs-progs.override {
    patches = [ patch ];
  };

  version = "0.04";

  src = fetchFromGitHub {
    owner = "Lakshmipathi";
    repo = "dduper";
    rev = "v${version}";
    sha256 = "09ncdawxkffldadqhfblqlkdl05q2qmywxyg6p61fv3dr2f2v5wm";
  };

  patch = stdenv.mkDerivation {
    name = "btrfs-csum.patch";

    inherit src;

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      cp patch/btrfs-progs-v5.6.1/0001-Print-csum-for-a-given-file-on-stdout.patch $out
    '';
  };
in
python3Packages.buildPythonPackage rec {
  pname = "dduper";

  inherit src version;

  buildInputs = [ our-btrfs-progs ];

  pythonPath = [ python3Packages.python
    python3Packages.numpy
    python3Packages.ptable ];

  prePatch = ''
    sed -i 's,/usr/sbin/btrfs\.static,'${our-btrfs-progs}/bin/btrfs, dduper
  '';

  doCheck = false;
  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    cp dduper $out/bin

    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Block-level out-of-band BTRFS dedupe tool";
    homepage = "https://github.com/Lakshmipathi/dduper";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
