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
    # fix macos patch
    (fetchpatch {
      url = "https://github.com/sshuttle/sshuttle/commit/884bd6deb0b699a5648bb1c7bdfbc7be8ea0e7df.patch";
      sha256 = "1nn0wx0rckxl9yzw9dxjji44zw4xqz7ws4qwjdvfn48w1f786lmz";
    })
  ];

  nativeBuildInputs = [ makeWrapper python3Packages.setuptools_scm ] ++ stdenv.lib.optional (stdenv.system != "i686-linux") pandoc;
  buildInputs =
    [ coreutils openssh procps nettools ]
    ++ stdenv.lib.optionals stdenv.isLinux [ iptables ];

  checkInputs = with python3Packages; [ mock pytest pytestrunner ];

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
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };
}
