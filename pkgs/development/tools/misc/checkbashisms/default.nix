{ lib, stdenv, fetchurl, perl, installShellFiles }:
stdenv.mkDerivation rec {
  version = "2.21.1";
  pname = "checkbashisms";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.xz";
    hash = "sha256-1ZbIiUrFd38uMVLy7YayLLm5RrmcovsA++JTb8PbTFI=";
  };

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ perl ];

  buildPhase = ''
    substituteInPlace ./scripts/checkbashisms.pl \
      --replace '###VERSION###' "$version"
  '';
  installPhase = ''
    installManPage scripts/$pname.1
    installShellCompletion --bash --name $pname scripts/$pname.bash_completion
    install -D -m755 scripts/$pname.pl $out/bin/$pname
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/checkbaskisms/";
    description = "Check shell scripts for non-portable syntax";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
