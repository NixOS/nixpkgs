{ lib, stdenv, fetchpatch, fetchFromGitHub, btrfs-progs, python3 }:

let
  btrfsProgsPatched = btrfs-progs.overrideAttrs (oldAttrs: {
    patches = [
      (fetchpatch {
        name = "0001-Print-csum-for-a-given-file-on-stdout.patch";
        url = "https://raw.githubusercontent.com/Lakshmipathi/dduper/8fab08e0f1901bf54411d25f1767b48c978074cb/patch/btrfs-progs-v5.9/0001-Print-csum-for-a-given-file-on-stdout.patch";
        sha256 = "1li9lslrap70ibad8sij3bgpxn5lqs0j10l60bmy3c36y866q3g1";
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
