{ stdenv, python, fetchFromGitHub }:

python.pkgs.buildPythonApplication rec {
  pname = "targetcli";
  version = "2.1.51";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
    sha256 = "07i9kyr525hlk32amzgycirwgwykdbjy5fmw6ji0nnhvk2jh4arn";
  };

  propagatedBuildInputs = with python.pkgs; [ configshell rtslib ];

  postInstall = ''
    install -D targetcli.8 -t $out/share/man/man8/
    install -D targetclid.8 -t $out/share/man/man8/
  '';

  meta = with stdenv.lib; {
    description = "A command shell for managing the Linux LIO kernel target";
    homepage = https://github.com/open-iscsi/targetcli-fb;
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
