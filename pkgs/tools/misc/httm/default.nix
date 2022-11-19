{stdenv, lib, fetchFromGitHub, rustPlatform}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    # Fix 0.17.5 branch, unfortunately tag upstream is wrong.
    rev = "b9870590bac18178ad2b16b99f3ac6be21dbb2c6";
    sha256 = "sha256-XkIpEqZzPrP4g2Nbk5TN9qaJoamg7LE2NLgYjx1ys2w=";
  };

  cargoSha256 = "sha256-S/Uc23HmM76kUVBpg3seDIUPo0lPcaP3BPB8u6tsEOM=";

  postInstall =
''
install -dm 755 "$out/share/man/man1"
gzip -c ./httm.1 > "$out/share/man/man1/httm.1.gz"
install -m 555 ./scripts/ounce.bash "$out/bin/ounce"
install -m 555 ./scripts/bowie.bash "$out/bin/bowie"
'';

  meta = with lib; {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    license = licenses.mpl20;
    maintainers = [ maintainers.CalvinBeck ];
  };
}
