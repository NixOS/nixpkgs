{ stdenv, lib, fetchFromGitHub, autoreconfHook, utillinux }:

stdenv.mkDerivation rec {
  pname = "swapspace";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "Tookmund";
    repo = "Swapspace";
    rev = "v${version}";
    sha256 = "06xvmyy1fp94h00k9nn929j00ca3w12fiz07wf9az6srxa8i4ndz";
  };

  nativeBuildInputs = [ autoreconfHook ];

  patchPhase = ''
    sed -e 's@"mkswap"@"${utillinux}/bin/mkswap"@' \
      -e 's@"/sbin/swapon"@"${utillinux}/bin/swapon"@' \
      -e 's@"/sbin/swapoff"@"${utillinux}/bin/swapoff"@' \
      -i src/support.c src/swaps.c
  '';

  postInstall = ''
    mkdir $out/bin
    mv $out/sbin/swapspace $out/bin/swapspace
    # This should be an empty directory, fail if not
    rmdir $out/sbin
    rm -r $out/var
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/Tookmund/Swapspace";
    description = "Dynamically add and remove swapfiles based on memory pressure";
    license = licenses.gpl2;
    maintainers = with maintainers; [ wmertens ];
    platforms = platforms.linux;
  };
}
