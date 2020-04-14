{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "shunit2";
  version = "2019-08-10";

  src = fetchFromGitHub {
    owner = "kward";
    repo = "shunit2";
    rev = "ba130d69bbff304c0c6a9c5e8ab549ae140d6225";
    sha256 = "1bsn8dhxbjfmh01lq80yhnld3w3fw1flh7nwx12csrp58zsvlmgk";
  };

  installPhase = ''
    mkdir -p $out/bin/
    cp ./shunit2 $out/bin/shunit2
    chmod +x $out/bin/shunit2
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/shunit2
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/kward/shunit2";
    description = "A xUnit based unit test framework for Bourne based shell scripts.";
    maintainers = with maintainers; [ cdepillabout utdemir ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
