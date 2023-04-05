{ lib, stdenv, fetchpatch, fetchFromGitHub, btrfs-progs, python3 }:

let
  btrfsProgsPatched = btrfs-progs.overrideAttrs (oldAttrs: {
    patches = [
      (fetchpatch {
        name = "0001-Print-csum-for-a-given-file-on-stdout.patch";
        url = "https://raw.githubusercontent.com/Lakshmipathi/dduper/ecc2664c380616ec75cfc1e600b5514cdff5c687/patch/btrfs-progs-v6.1/0001-Print-csum-for-a-given-file-on-stdout.patch";
        sha256 = "sha256-M4LT7G6gwBfSXf6EL4pxNoQJMyUTOA+ojxEJqw2yss4=";
      })
    ];
  });
  py3 = python3.withPackages (ps: with ps; [
    prettytable
    numpy
  ]);
in
stdenv.mkDerivation rec {
  pname = "dduper";
  version = "0.04";

  src = fetchFromGitHub {
    owner = "lakshmipathi";
    repo = "dduper";
    rev = "v${version}";
    sha256 = "09ncdawxkffldadqhfblqlkdl05q2qmywxyg6p61fv3dr2f2v5wm";
  };

  buildInputs = [
    btrfsProgsPatched
    py3
  ];

  patchPhase = ''
    substituteInPlace ./dduper --replace "/usr/sbin/btrfs.static" "${btrfsProgsPatched}/bin/btrfs"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 ./dduper $out/bin
  '';

  meta = with lib; {
    description = "Fast block-level out-of-band BTRFS deduplication tool.";
    homepage = "https://github.com/Lakshmipathi/dduper";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ thesola10 ];
    platforms = platforms.linux;
  };
}
