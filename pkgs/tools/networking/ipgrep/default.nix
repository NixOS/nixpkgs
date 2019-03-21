{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper }:

pythonPackages.buildPythonApplication rec {
  version = "1.0";
  pname = "ipgrep";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = version;
    sha256 = "1qaxvbqdalvz05aplhhrg7s4h7yx4clbfd50k46bgavhgcqqv8n3";
  };

  patchPhase = ''
    mkdir -p ${pname} 
    substituteInPlace setup.py \
      --replace "'scripts': []" "'scripts': { '${pname}.py' }"
  '';

  propagatedBuildInputs = with pythonPackages; [
    pycares
    urllib3
    requests
  ];

  meta = with stdenv.lib; {
    description = "Extract, defang, resolve names and IPs from text";
    longDescription = ''
      ipgrep extracts possibly obfuscated host names and IP addresses
      from text, resolves host names, and prints them, sorted by ASN.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.all;
  };
}
