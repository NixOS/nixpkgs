{ stdenv, python, fetchFromGitHub }:

python.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.50";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "0xrvby63i39rvi778bnvnxacghaix63q72vzxdc3i87ji1ki58hc";
  };

  propagatedBuildInputs = with python.pkgs; [ configshell rtslib ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
  '';

  meta = with stdenv.lib; {
    description = "A command shell for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/targetcli-fb;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
