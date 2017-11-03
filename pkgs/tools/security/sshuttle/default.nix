{ stdenv, python3Packages, fetchurl, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps, fetchpatch }:

python3Packages.buildPythonApplication rec {
  name = "sshuttle-${version}";
  version = "0.78.3";

  src = fetchurl {
    sha256 = "12xyq5h77b57cnkljdk8qyjxzys512b73019s20x6ck5brj1m8wa";
    url = "mirror://pypi/s/sshuttle/${name}.tar.gz";
  };

  patches = [
    ./sudo.patch
    (fetchpatch {
      url = "https://github.com/sshuttle/sshuttle/commit/91aa6ff625f7c89a19e6f8702425cfead44a146f.patch";
      sha256 = "0sqcc6kj53wlas2d3klbyilhns6vakzwbbp8y7j9wlmbnc530pks";
    })
  ];

  nativeBuildInputs = [ makeWrapper pandoc python3Packages.setuptools_scm ];
  buildInputs =
    [ coreutils openssh ] ++
    stdenv.lib.optionals stdenv.isLinux [ iptables nettools procps ];

  checkInputs = with python3Packages; [ mock pytest pytestrunner ];

  # Tests only run with Python 3. Server-side Python 2 still works if client
  # uses Python 3, so it should be fine.
  doCheck = true;

  postInstall = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
  wrapProgram $out/bin/sshuttle \
    --prefix PATH : "${mapPath (x: "${x}/bin") buildInputs}" \
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sshuttle/sshuttle/;
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2 at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    maintainers = with maintainers; [ domenkozar nckx ];
    platforms = platforms.unix;
  };
}
