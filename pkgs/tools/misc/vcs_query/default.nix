{ stdenv, python3, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "vcs_query";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mageta";
    repo = "vcs_query";
    rev = "v${version}";
    sha256 = "05va0na9yxkpqhm9v0x3k58148qcf2bbcv5bnmj7vn9r7fwyjrlx";
  };

  nativeBuildInputs = [ python3 python3.pkgs.wrapPython ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 vcs_query.py $out/bin/vcs_query
    patchShebangs $out/bin
    buildPythonPath ${python3.pkgs.vobject};
    patchPythonScript $out/bin/vcs_query
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mageta/vcs_query;
    description = "eMail query-command to use vCards in mutt and Vim";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
