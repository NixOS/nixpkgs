{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "convbin";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "mateoconlechuga";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n502zj8igm583kbfvyv7zhd97vb71jac41ncb9jr2yz2v5ir8j9";
  };

  makeFlags = [ "CC=cc" ];

  checkPhase = ''
    pushd test
    patchShebangs test.sh
    ./test.sh
    popd
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bin/convbin $out/bin/convbin
  '';

  meta = with stdenv.lib; {
    description = "Converts files to other formats";
    longDescription = ''
      This program is used to convert files to other formats,
      specifically for the TI84+CE and related calculators.
    '';
    homepage = "https://github.com/mateoconlechuga/convbin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
