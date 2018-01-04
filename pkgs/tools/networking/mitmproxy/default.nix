{ stdenv, fetchpatch, fetchFromGitHub, fetchurl, python3, glibcLocales }:

let
  # When overrides are not needed, then only remove the contents of this set.
  packageOverrides = self: super: {
    ldap3 = super.ldap3.overridePythonAttrs (oldAttrs: rec {
      version = "2.3";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "c056b3756076e15aa71c963c7c5a44d5d9bbd430263ee49598d4454223a766ac";
      };
    });
    pyasn1 = super.pyasn1.overridePythonAttrs (oldAttrs: rec {
      version = "0.3.7";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "187f2a66d617683f8e82d5c00033b7c8a0287e1da88a9d577aebec321cad4965";
      };
    });
  };

  pythonPackages = (python3.override {inherit packageOverrides; }).pkgs;
in with pythonPackages;

buildPythonPackage rec {
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

  propagatedBuildInputs = [
    blinker click certifi cryptography
    h2 hyperframe
    kaitaistruct passlib pyasn1 pyopenssl
    pyparsing pyperclip requests ruamel_yaml tornado
    urwid brotlipy sortedcontainers ldap3
  ];

  buildInputs = [
    beautifulsoup4 flask pytest pytestrunner glibcLocales
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage = http://mitmproxy.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
