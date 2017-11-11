{ stdenv, fetchpatch, fetchFromGitHub, fetchurl, python3, glibcLocales }:

python3.pkgs.buildPythonPackage rec {
  baseName = "mitmproxy";
  name = "${baseName}-unstable-2017-10-31";

  src = fetchFromGitHub {
    owner = baseName;
    repo = baseName;
    rev = "80a8eaa708ea31dd9c5e7e1ab6b02c69079039c0";
    sha256 = "0rvwm11yryzlp3c1i42rk2iv1m38yn6r83k41jb51hwg6wzbwzvw";
  };

  checkPhase = ''
    export HOME=$(mktemp -d)
    # test_echo resolves hostnames
    LC_CTYPE=en_US.UTF-8 pytest -k 'not test_echo and not test_find_unclaimed_URLs '
  '';

  propagatedBuildInputs = with python3.pkgs; [
    blinker click certifi cryptography
    h2 hyperframe
    kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests ruamel_yaml tornado
    urwid brotlipy sortedcontainers ldap3
  ];

  buildInputs = with python3.pkgs; [
    beautifulsoup4 flask pytest pytestrunner glibcLocales
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = http://mitmproxy.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
