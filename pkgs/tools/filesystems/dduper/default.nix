{ lib, stdenv, fetchpatch, fetchFromGitHub, btrfs-progs, python3 }:

let
  btrfsProgsPatched = btrfs-progs.overrideAttrs (oldAttrs: {
    patches = [
      (fetchpatch {
        name = "0001-Print-csum-for-a-given-file-on-stdout.patch";
        url = "https://raw.githubusercontent.com/Lakshmipathi/dduper/f45d04854a40cb52ae0e6736916d5955cb68b8ee/patch/btrfs-progs-v5.12.1/0001-Print-csum-for-a-given-file-on-stdout.patch";
        sha256 = "0c7dd44q2ww6k9nk5dh6m0f0wbd8x84vb2m61fk6a44nsv2fwz1x";
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
