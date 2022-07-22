{ stdenv, lib, fetchFromGitHub, gnat, gprbuild }:

stdenv.mkDerivation {
  pname = "alire";
  version = "1.3-dev-2022-06-24";
  src = fetchFromGitHub {
    owner = "alire-project";
    repo = "alire";
    rev = "8f44a810";
    hash = "sha256-kYntEMeVPo1+gRI+Q/6qfSyICXNf8yLT+LcbuyeRu/E=";
    fetchSubmodules = true;
  };

  OS = if stdenv.isDarwin then "macOS" else null;

  nativeBuildInputs = [ gnat gprbuild ];

  buildPhase = ''
    runHook preBuild
    gprbuild -j0 -P alr_env
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    gprinstall --mode=usage -P alr_env -p -r --prefix=$out
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/alire-project/alire";
    description = "Ada LIbrary REpository";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ethindp ];
  };
}
