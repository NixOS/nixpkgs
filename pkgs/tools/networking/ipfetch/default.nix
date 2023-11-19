{ stdenv, lib, fetchFromGitHub, bash, wget, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ipfetch";
  version = "unstable-2022-03-24";

  src = fetchFromGitHub {
    owner = "trakBan";
    repo = "ipfetch";
    rev = "fc295bfda4f9fea6eee9f6f3f2dabc26b6f25be4";
    sha256 = "sha256-YKQ9pRBj2hgPg2ShCqWGxzHs/n7kNhKRNyElRDwHDBU=";
  };

  strictDeps = true;
  buildInputs = [ bash wget ];
  nativeBuildInputs = [ makeWrapper ];
  postPatch = ''
    patchShebangs --host ipfetch
    # Not only does `/usr` have to be replaced but also `/flags` needs to be added because with Nix the script is broken without this. The `/flags` is somehow not needed if you install via the install script in the source repository.
    substituteInPlace ./ipfetch --replace /usr/share/ipfetch $out/usr/share/ipfetch/flags
  '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/usr/share/ipfetch/
    cp -r flags $out/usr/share/ipfetch/
    cp ipfetch $out/bin/ipfetch
    wrapProgram $out/bin/ipfetch --prefix PATH : ${
      lib.makeBinPath [ bash wget ]
    }
  '';

  meta = with lib; {
    description = "Neofetch but for ip addresses";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
